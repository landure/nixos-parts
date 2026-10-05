/**
  # diffnav

  Git diff pager based on delta but with a file tree, à la GitHub.

  ## 🛠️ Tech Stack

  - [diffnav @ GitHub](https://github.com/dlvhdr/diffnav).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.git @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable).
  - [programs.git @ NixOS reference](https://search.nixos.org/options?query=programs.git.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf mkMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types)
    attrsOf
    bool
    int
    listOf
    oneOf
    package
    str
    ;

  cfg = config.biapy.programs.diffnav;
  deltaCfg = config.programs.delta;
in
{
  options.biapy.programs.diffnav = {
    enable = mkEnableOption "diffnav, a git diff pager with a file tree";

    package = mkOption {
      type = package;
      default = pkgs.diffnav;
      defaultText = "pkgs.diffnav";
      description = "The diffnav package to use.";
    };

    settings = mkOption {
      type = attrsOf (oneOf [
        bool
        int
        str
        (listOf str)
        (attrsOf (oneOf [
          bool
          int
          str
        ]))
      ]);
      default = { };
      example = {
        ui.hideHeader = true;
        ui.hideFooter = true;
        ui.showFileTree = true;
        ui.fileTreeWidth = 26;
        ui.icons = "nerd-fonts-status";
        ui.colorFileNames = true;
        ui.showDiffStats = true;
        ui.sideBySide = true;
        ui.startFoldersOpenDepth = -1;
        ui.theme = "tokyo_night";
      };
      description = ''
        Options to configure diffnav.

        These are written to {file}`~/.config/diffnav/config.yml`.
      '';
    };

    enableGitIntegration = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable git integration for diffnav.

        When enabled, diffnav will be configured as git's pager for diffs.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ cfg.package ];

      xdg.configFile."diffnav/config.yml" = mkIf (cfg.settings != { }) {
        text = lib.generators.toYAML { } cfg.settings;
      };
    })
    (mkIf (cfg.enable && cfg.enableGitIntegration) {
      programs = {
        delta.enable = mkDefault true;

        git.iniContent =
          let
            diffnavCommand = getExe cfg.package;
            deltaCommand = getExe deltaCfg.package;
          in
          {
            pager = {
              diff = diffnavCommand;
              log = deltaCommand;
              show = deltaCommand;
              blame = deltaCommand;
            };

            interactive.diffFilter = "${deltaCommand} --color-only";

            delta = deltaCfg.options;
          };
      };
    })
  ];
}
