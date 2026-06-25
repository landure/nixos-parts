/**
  # Skim

  Skim fuzzy finder, with custom setup & aliases

  ## 🛠️ Tech Stack

  - [skim @ GitHub](https://github.com/skim-rs/skim).
  - [fd @ GitHub](https://github.com/sharkdp/fd).
  - [bat @ GitHub](https://github.com/sharkdp/bat).
  - [ripgrep (rg) @ GitHub](https://github.com/BurntSushi/ripgrep).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.skim](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.skim.enable).
  - [programs.fd](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable).
  - [programs.bat](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable).
  - [programs.ripgrep](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable).

  ## 🙇 Acknowledgements

  - [FZF vs Skim (October 2025): which fuzzy finder should power your terminal? @ GitgasBlade](https://gigasblade.blogspot.com/2025/10/fzf-vs-skim-october-2025-which-fuzzy.html).
  - [Supercharging the shell @ On data, programming, and technology](https://ivergara.github.io/Supercharging-shell.html).
  - [Use CLI like a modern tech bro @ tsukie](https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.skim;

in
{
  options = {
    biapy.programs.skim = {
      enable = mkEnableOption "skim";
    };
  };

  config = mkIf cfg.enable {

    programs = {
      fd.enable = mkDefault true;
      bat.enable = mkDefault true;
      ripgrep.enable = mkDefault true;

      skim = {
        enable = mkDefault true;
        # defaultCommand = "rg --files || fd || find .";
        defaultCommand = config.programs.skim.fileWidgetCommand;

        defaultOptions = [
          "--height 40%"
          "--prompt='⟫'"
        ];
        # ALT-C
        changeDirWidgetCommand = mkDefault "${getExe config.programs.fd.package} --type 'd' --hidden --follow --exclude '.git'";
        changeDirWidgetOptions = mkDefault [
          "--preview 'tree -C {} | head -200'"
        ];

        # CTRL-T
        fileWidgetCommand = mkDefault "${getExe config.programs.fd.package} --type 'f' --hidden --follow --exclude '.git'";
        fileWidgetOptions = mkDefault [
          "--preview='${getExe config.programs.bat.package} --style=numbers --color=always --line-range :500 {}"
          "--preview-window='right:60%:wrap'"
        ];

        # CTRL-R
        historyWidgetOptions = mkDefault [
          "--tac"
          "--exact"
        ];
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "skf" ''
        # A comfortable UI + preview
        ${getExe config.programs.skim.package} --ansi --prompt='Files> ' \
          --preview='${getExe config.programs.bat.package} --style=numbers --color=always --line-range :500 {}' \
          --preview-window='right:60%:wrap'
      '')

      (pkgs.writeShellScriptBin "skrg" ''
        # Live grep
        ${getExe config.programs.skim.package} --ansi --delimiter ':' --interactive \
          --cmd='${getExe config.programs.ripgrep.package} --line-number --no-heading --color=always {q}' \
          --preview='${getExe config.programs.bat.package} --style=numbers --color=always --highlight-line {2} {1}' \
          --preview-window='right:70%:wrap' \
          --cmd-query="''${@}"
      '')

      (pkgs.writeShellScriptBin "skvim" ''
        # Open with Neovim.
        # Should use xargs.
        # see https://ivergara.github.io/Supercharging-shell.html
        ${getExe config.programs.skim.package} --ansi \
        --bind "ctrl-p:toggle-preview" \
        --preview="${getExe config.programs.bat.package} --style=numbers --color=always '{}'" \
        --preview-window='right:60%:hidden' |
        xargs -I '{}' ${getExe config.programs.neovim.package} {}
      '')

      (pkgs.writeShellScriptBin "skhx" ''
        # Open with Helix.
        # see https://ivergara.github.io/Supercharging-shell.html
        ${getExe config.programs.skim.package} --ansi \
        --bind "ctrl-p:toggle-preview" \
        --preview="${getExe config.programs.bat.package} --style=numbers --color=always '{}'" \
        --preview-window='right:60%:hidden' |
        xargs -I '{}' ${getExe config.programs.helix.package} {}
      '')

      (pkgs.writeShellScriptBin "skvs" ''
        # Open with VS code.
        # see https://ivergara.github.io/Supercharging-shell.html
        set -o pipefail
        ${getExe config.programs.skim.package} --ansi \
        --bind "ctrl-p:toggle-preview" \
        --preview="${getExe config.programs.bat.package} --color=always {}" \
        --preview-window='right:60%:hidden' |
        xargs -I '{}' ${getExe config.programs.vscode.package} :w {}
      '')
    ];
  };

  nix-unit.tests."biapy.programs.skim" =
    let
      inherit (lib) any getName;

      containsPackage = name: packages: any (pkg: getName pkg == name) packages;
    in
    {
      default =
        let
          sut = {
            biapy.programs.skim.enable = true;
          };
        in
        {
          "test: skim is enabled" = {
            expr = sut.config.programs.skim.enable;
            expected = true;
          };

          "test: fd is enabled" = {
            expr = sut.config.programs.fd.enable;
            expected = true;
          };

          "test: bat is enabled" = {
            expr = sut.config.programs.bat.enable;
            expected = true;
          };

          "test: ripgrep is enabled" = {
            expr = sut.config.programs.ripgrep.enable;
            expected = true;
          };

          "test: custom shell script skf is installed" = {
            expr = containsPackage "skf" sut.config.home.packages;
            expected = true;
          };

          "test: custom shell script skrg is installed" = {
            expr = containsPackage "skrg" sut.config.home.packages;
            expected = true;
          };

          "test: custom shell script skvim is installed" = {
            expr = containsPackage "skvim" sut.config.home.packages;
            expected = true;
          };

          "test: custom shell script skhx is installed" = {
            expr = containsPackage "skhx" sut.config.home.packages;
            expected = true;
          };

          "test: custom shell script skvs is installed" = {
            expr = containsPackage "skvs" sut.config.home.packages;
            expected = true;
          };
        };
    };
}
