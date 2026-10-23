/**
  # abtop

  abtop is a TUI to monitor Claude Code & Codex CLI sessions, tokens,
  context window, rate limits, and ports in real-time.

  ## 🛠️ Tech Stack

  - [abtop @ GitHub](https://github.com/graykode/abtop).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.biapy.programs.abtop;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.biapy.programs.abtop = {
    enable = mkEnableOption "abtop";
    package = mkPackageOption pkgs.unstable "abtop" { };
    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = {
        language = "en";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    xdg.configFile = {
      "abtop/config.toml" = mkDefault (
        mkIf (cfg.settings != { }) {
          source = settingsFormat.generate "abtop-config.toml" cfg.settings;
        }
      );
    };
  };
}
