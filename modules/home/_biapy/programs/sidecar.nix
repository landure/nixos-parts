/**
  # sidecar

  Sidecar is a TUI for managing multiple AI coding agents.

  ## 🛠️ Tech Stack

  - [sidecar @ GitHub](https://github.com/marcus/sidecar).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) attrs;

  cfg = config.biapy.programs.sidecar;
in
{
  options.biapy.programs.sidecar = {
    enable = mkEnableOption "sidecar";

    package = mkPackageOption pkgs.llm-agents "sidecar" { };

    settings = mkOption {
      type = attrs;
      default = { };
      description = ''
        Settings written to {file}`~/.config/sidecar/config.json`
        when non-empty.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."sidecar/config.json" = mkIf (cfg.settings != { }) {
      text = builtins.toJSON cfg.settings;
    };
  };
}
