/**
  # Joplin TUI

  ## 🛠️ Tech Stack

  - [Joplin homepage](https://joplinapp.org/)
    ([Joplin @ GitHub](https://github.com/laurent22/joplin/)).
  - [Joplin Terminal Application @ Joplin](https://joplinapp.org/help/apps/terminal/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.joplin-desktop @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.joplin-desktop.).
*/
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets)
    attrValues
    mapAttrs
    mergeAttrsList
    optionalAttrs
    ;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.joplin-cli;

  syncTargetId =
    {
      "undefined" = null;
      "none" = 0;
      "file-system" = 2;
      "onedrive" = 3;
      "nextcloud" = 5;
      "webdav" = 6;
      "dropbox" = 7;
      "s3" = 8;
      "joplin-server" = 9;
      "joplin-cloud" = 10;
    }
    .${cfg.sync.target};

  syncEnabled = syncTargetId != null && syncTargetId != 0;

  syncSettings = mergeAttrsList (
    attrValues (
      mapAttrs (
        name: value:
        let
          prefix = "sync.${builtins.toString syncTargetId}";
        in
        {
          "${prefix}.${name}" = value;
        }
      ) cfg.sync.settings
    )
  );
in
{
  options = {
    biapy.programs.joplin-cli = {
      enable = mkEnableOption "Joplin CLI";

      sync = {
        interval = options.programs.biapy.joplin-desktop.sync.interval // {
          default = config.programs.biapy.joplin-desktop.sync.interval;
        };
        target = options.programs.biapy.joplin-desktop.sync.target // {
          default = config.programs.biapy.joplin-desktop.sync.target;
        };
        settings = options.programs.biapy.joplin-desktop.sync.settings // {
          default = config.programs.biapy.joplin-desktop.sync.settings;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # shellAliases = {
    #   joplin = mkDefault ''joplin --profile "''${XDG_CONFIG_HOME}/joplin-desktop"'';
    # };

    home.packages = with pkgs; [
      joplin-cli
    ];

    home.activation = {
      activateJoplinCliConfig =
        let
          inherit (lib.attrsets) filterAttrs;
          inherit (lib.hm.dag) entryAfter;

          configPath = "${config.xdg.configHome}/joplin/settings.json";

          jq_exe = getExe pkgs.jq;
          jsonFormat = pkgs.formats.json { };

          newConfig = jsonFormat.generate "joplin-settings.json" (
            filterAttrs (_n: v: (v != null) && (v != "")) (
              {
                "sync.target" = syncTargetId;
                "locale" = "fr_FR";
              }
              // (optionalAttrs syncEnabled syncSettings)
            )
          );
        in
        mkDefault (
          entryAfter [ "linkGeneration" ] ''
            # Ensure that settings.json exists.
            mkdir -p '${dirOf configPath}'
            touch '${configPath}'
            # Config has to be written to temporary variable because jq cannot edit files in place.
            config="$(${jq_exe} -s '.[0] + .[1]' '${configPath}' '${newConfig}')"
            printf '%s\n' "''${config}" > '${configPath}'
            unset 'config'
          ''
        );
    };
  };
}
