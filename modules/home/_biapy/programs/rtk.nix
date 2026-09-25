/**
  # RTK

  RTK is a CLI proxy that reduces LLM token consumption by 60-90%
  on common dev commands.

  When OpenCode is enabled, the RTK OpenCode plugin is installed so that
  `bash`/`shell` tool commands are transparently rewritten through
  `rtk rewrite` for token savings.

  ## 🛠️ Tech Stack

  - [RTK homepage](https://www.rtk-ai.app/).
  - [RTK @ GitHub](https://github.com/rtk-ai/rtk).
  - [RTK OpenCode plugin @ GitHub](https://github.com/rtk-ai/rtk/blob/develop/hooks/opencode/rtk.ts).
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
  inherit (pkgs) fetchurl;

  cfg = config.biapy.programs.rtk;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.biapy.programs.rtk = {
    enable = mkEnableOption "RTK";
    package = mkPackageOption pkgs.unstable "rtk" { };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = {
        tracking = {
          enabled = true;
          history_days = 90;
        };
        display = {
          colors = true;
          emoji = true;
          max_width = 120;
        };
        filters = {
          ignore_dirs = [
            ".git"
            "node_modules"
            "target"
            "__pycache__"
            ".venv"
            "vendor"
          ];
          ignore_files = [
            "*.lock"
            "*.min.js"
            "*.min.css"
          ];
        };

        retriever = {
          mode = "sqlite";
          max_entry_bytes = 10485760;
          max_entries = 200;
          retention_days = 30;
          compression = true;
          tee_max_files = 20;
          tee_max_file_size = 1048576;
          tee_on_success = false;
        };
        telemetry = {
          enabled = false;
          consent_given = false;
        };

        hooks = {
          exclude_commands = [ ];
          transparent_prefixes = [ ];
        };
        limits = {
          grep_max_results = 200;
          grep_max_per_file = 25;
          status_max_files = 15;
          status_max_untracked = 10;
          passthrough_max_chars = 2000;
        };
        awareness = {
          level = "default";
        };
      };
    };

    filters = lib.mkOption {
      inherit (settingsFormat) type;
      default = {
      };
      example = {
        "filters.my-global-tool" = {
          description = "Compact my-global-tool output";
          match_command = "^my-global-tool\\b";
          strip_ansi = true;
          strip_lines_matching = [ "^\\s*$" ];
          max_lines = 40;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "rtk/config.toml" = mkDefault (
        mkIf (cfg.settings != { }) {
          source = settingsFormat.generate "rtk-config.toml" cfg.settings;
        }
      );

      "rtk/filters.toml" = mkDefault {
        source = settingsFormat.generate "rtk-filters.toml" ({ schema_version = 1; } // cfg.filters);
      };
    }
    # Install the OpenCode plugin only when OpenCode is enabled.
    # The plugin requires `rtk` in PATH (provided by home.packages above).
    // (mkIf config.programs.opencode.enable {
      "opencode/plugins/rtk.ts".source = mkDefault (fetchurl {
        url = "https://raw.githubusercontent.com/rtk-ai/rtk/2bf3eb7697b70c88314378e2b8d13f7303b8545b/hooks/opencode/rtk.ts";
        hash = "sha256-ZTDBMZRshIkvlSKr1o1OUT4eZY2N260fWTiMhuu8trs=";
      });
    });
  };
}
