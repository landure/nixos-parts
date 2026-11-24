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

  - [programs.skim @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/skim.html).
  - [programs.fd @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/fd.html).
  - [programs.bat @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/bat.html).
  - [programs.ripgrep @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/ripgrep.html).

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
  inherit (lib.lists) optionals;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkAfter mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.skim;

in
{
  options.biapy.programs.skim.enable = mkEnableOption "skim";

  config = mkIf cfg.enable {
    biapy.programs = {
      bat.enable = mkDefault true;
      ripgrep.enable = mkDefault true;
    };

    # home.shellAliases = {
    #  scd = ''scd_function() { local git_root_or_working="$(git rev-parse --show-toplevel 2>/dev/null || pwd)" && local target="''${git_root_or_working}/$(fd --base-directory="''${git_root_or_working}" --type 'd' | sk --query="''${1}")" && cd "''${target}"; }; scd_function'';
    # };

    programs = {
      bash.initExtra = mkAfter ''
        scd() {
          local find_base="$(
              git rev-parse --show-toplevel 2>/dev/null ||
              pwd
            )"
          local target
          local selection

          selection="$(
              fd --base-directory="''${find_base}" --type 'd' |
              sk --query="''${1}"
            )" ||
            return 1

          target="''${find_base}/''${selection}"
          cd "''${target}"
        }
      '';

      fd.enable = mkDefault true;
      git.enable = mkDefault true;

      skim = {
        enable = mkDefault true;
        # defaultCommand = "rg --files || fd || find .";
        defaultCommand = config.programs.skim.fileWidgetCommand;

        defaultOptions = [
          # "--height 40%"
          "--prompt='❯ '"
        ];
        # ALT-C
        changeDirWidgetCommand = mkDefault "${getExe config.programs.fd.package} --type 'd' --hidden --follow --exclude '.git'";
        changeDirWidgetOptions = mkDefault [
          "--preview 'tree -C {} | head -200'"
        ];

        # CTRL-T
        fileWidgetCommand = mkDefault "${getExe config.programs.fd.package} --type 'f' --hidden --follow --exclude '.git'";
        fileWidgetOptions = mkDefault [
          "--preview='test -f {} && ${getExe config.programs.bat.package} --style=numbers --color=always --line-range :500 {}'"
          "--preview-window='right:60%:nowrap'"
        ];

        # CTRL-R
        historyWidgetOptions = mkDefault [
          "--tac"
          "--exact"
        ];
      };
    };

    home.packages =
      with pkgs.biapy-parts;
      [
        skf
        skrg
        skat
        skrat
        sked
        skred
      ]
      ++ (optionals config.programs.neovim.enable (
        with pkgs.biapy-parts;
        [
          skvim
          skrvim
        ]
      ))
      ++ (optionals config.programs.helix.enable (
        with pkgs.biapy-parts;
        [
          skhx
          skrhx
        ]
      ))
      ++ (optionals config.programs.vscode.enable (
        with pkgs.biapy-parts;
        [
          skode
          skrode
        ]
      ))
      ++ (optionals config.programs.vscodium.enable (
        with pkgs.biapy-parts;
        [
          skodium
          skrodium
        ]
      ));
  };
}
