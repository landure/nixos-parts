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
*/
{
  config,
  ...
}:
let

  module =
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

      cfg = config.biapy.home.programs.skim;

    in
    {
      options = {
        biapy.home.programs.skim = {
          enable = mkEnableOption "skim";
        };
      };

      config = mkIf cfg.enable {

        programs.fd.enable = mkDefault true;
        programs.bat.enable = mkDefault true;
        programs.ripgrep.enable = mkDefault true;

        programs.skim = {
          enable = mkDefault true;
          defaultCommand = "${getExe config.programs.fd.package} --type 'f' --hidden --follow --exclude '.git'";
        };

        home.packages = [
          (pkgs.writeShellScriptBin "skf" ''
            # A comfortable UI + preview
            ${getExe config.programs.skim.package} --ansi --prompt='Files> ' \
              --preview '${getExe config.programs.bat.package} --style=numbers --color=always --line-range :500 {}' \
              --preview-window='right:60%:wrap'
          '')

          (pkgs.writeShellScriptBin "skrg" ''
            # Live grep
            ${getExe config.programs.skim.package} --ansi --delimiter ':' \
              -c '${getExe config.programs.ripgrep.package} --line-number --no-heading --color=always "{}"' \
              --preview '${getExe config.programs.bat.package} --style=numbers --color=always --highlight-line {2} {1}' \
              --preview-window='right:70%:wrap'
          '')
        ];
      };
    };
in
{
  flake = {
    biapy.home."programs.skim" = module;

    tests = {
      "biapy.home.\"programs.skim\"" = {
        "test: declare module" = {
          expr = config.flake.biapy.home ? "programs.skim";
          expected = true;
        };
      };
    };

  };
}
