{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.lists) optional;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;

  cfg = config.biapy.programs.herdr;

  tomlFormat = pkgs.formats.toml { };
  generatedSettings = tomlFormat.generate "herdr-settings.toml" cfg.settings;
  jaq = lib.getExe pkgs.jaq;
  # Match the merger's TOML serialization so unchanged mutable files can be
  # replaced by a store link when mutableSettings is disabled.
  settingsSource = pkgs.runCommand "herdr-config.toml" { } ''
    settings="$(${jaq} --from toml --to toml '.' ${generatedSettings})"
    printf '%s\n' "$settings" > "$out"
  '';
  settingsPath = "${config.xdg.configHome}/herdr/config.toml";

  # Declared values win, settings added by Herdr or the user are preserved.
  mutableSettingsActivation = ''
    mkdir -p '${dirOf settingsPath}'
    if [ -f '${settingsPath}' ]; then
      merged="$(${jaq} --from toml --to json '.' ${settingsSource})"
      current="$(${jaq} --from toml --to json '.' '${settingsPath}')"
      ${jaq} -n --argjson static "$merged" --argjson dynamic "$current" \
        '$dynamic * $static' \
        | ${jaq} --from json --to toml '.' \
        > '${settingsPath}.tmp'
      mv '${settingsPath}.tmp' '${settingsPath}'
    else
      install -m 600 '${settingsSource}' '${settingsPath}'
    fi
  '';

  herdrBin = if cfg.package == null then "herdr" else lib.escapeShellArg (getExe cfg.package);
  reloadConfig = "${herdrBin} server reload-config || true";
in
{
  options.biapy.programs.herdr = {
    enable = mkEnableOption "Herdr";

    package = mkPackageOption pkgs.llm-agents "herdr" { nullable = true; };

    app = {
      enable = mkEnableOption "Herdr desktop app";
      package = mkPackageOption pkgs.llm-agents "herdr-app" { };
    };

    mutableSettings = mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to merge declared settings into a writable Herdr configuration
        file during activation, preserving settings added by Herdr or the user.
        Declared values, including arrays, take precedence. Removing a
        declaration does not remove it from the file. Comments and formatting
        are not preserved. New files have mode 0600; existing files retain
        their permissions.

        The default keeps the configuration file immutable. Switching back to
        immutable settings automatically replaces the writable file only when
        it is byte-identical to the declared settings. Changed files use Home
        Manager's normal collision and backup handling. Empty settings leave
        the file unmanaged.
      '';
    };

    settings = mkOption {
      inherit (tomlFormat) type;
      default = {
        onboarding = false;
        terminal = {
          default_shell = "zsh";
          shell_mode = "auto";
          new_cwd = "follow";
        };
        theme = {
          name = "catppuccin";
          auto_switch = false;
          light_name = "catppuccin-latte";
          dark_name = "catppuccin";
        };
        ui = {
          sidebar_width = 32;
          agent_panel_sort = "priority";
          toast.delivery = "herdr";
          sound.enabled = true;
        };
        keys.prefix = "ctrl+b";
      };
      example = {
        onboarding = false;
        terminal = {
          default_shell = "nu";
          shell_mode = "auto";
          new_cwd = "follow";
        };
        theme = {
          name = "catppuccin";
          auto_switch = true;
          light_name = "catppuccin-latte";
          dark_name = "catppuccin";
        };
        ui = {
          sidebar_width = 32;
          agent_panel_sort = "priority";
          toast.delivery = "herdr";
          sound.enabled = true;
        };
        keys.prefix = "ctrl+b";
        keys.command = [
          {
            key = "prefix+l";
            type = "plugin_action";
            command = "example.layout.apply";
            description = "apply layout";
          }
        ];
      };
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/herdr/config.toml`.
        See <https://herdr.dev/docs/configuration/> for the full list of options.
      '';
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        (optional (cfg.package != null) cfg.package) ++ (optional cfg.app.enable [ cfg.app.package ]);

      activation.herdrMutableSettings = lib.mkIf (cfg.mutableSettings && cfg.settings != { }) (
        lib.hm.dag.entryAfter [ "linkGeneration" ] (
          mutableSettingsActivation
          + ''
            run ${reloadConfig}
          ''
        )
      );
      activation.herdrImmutableSettings = mkIf (!cfg.mutableSettings && cfg.settings != { }) (
        lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
          # Remove the writable file left by a previous mutable run so the
          # store link can be created without a collision.
          rm -f '${settingsPath}'
        ''
      );
    };

    xdg.configFile."herdr/config.toml" = mkIf (!cfg.mutableSettings && cfg.settings != { }) {
      source = settingsSource;
      onChange = reloadConfig;
    };
  };
}
