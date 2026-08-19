/**
  # Graphical console terminal emulators

  ## 🛠️ Tech Stack

  - [Foot @ Codeberg](https://codeberg.org/dnkl/foot).
  - [Ghostty homepage](https://ghostty.org/)
    ([Ghostty @ GitHub](https://github.com/ghostty-org/ghostty)).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.attrsets) attrNames;
  inherit (lib.lists) elem;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) listOf enum;
  inherit (lib.meta) getExe;

  cfg = config.biapy.desktop.console;

  terminalEmulatorCommands = {
    ghostty = getExe config.programs.ghostty.package;
    foot = getExe config.programs.foot.package;
  };

  terminalEmulators = attrNames terminalEmulatorCommands;
in
{
  options = {
    biapy.desktop.console = {
      enable = mkEnableOption "Terminal Emulators";

      terminals = mkOption {
        type = listOf (enum terminalEmulators);
        default = [ "ghostty" ];
        description = ''
          What terminal emulators to enable.
        '';
      };

      default = mkOption {
        type = enum cfg.terminals;
        default = "ghostty";
        description = ''
          Prefered terminal emulator
        '';
        apply = default: terminalEmulatorCommands."${default}";
      };
    };
  };

  config = mkIf cfg.enable {
    biapy.programs = {
      foot.enable = mkDefault (elem "ghostty" cfg.terminals);
      ghostty.enable = mkDefault (elem "foot" cfg.terminals);
    };
  };
}
