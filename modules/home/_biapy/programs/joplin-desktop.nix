/**
  # Joplin desktop & TUI

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
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrs;

  cfg = config.biapy.programs.joplin-desktop;

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
    biapy.programs.joplin-desktop = {
      enable = mkEnableOption "Joplin";

      sync = {
        inherit (options.programs.joplin-desktop.sync) interval target;
        settings = mkOption {
          type = attrs;
          default = { };
          example = {
            "path" = "https://joplin.example.com/";
            "username" = "username@example.com";
          };
          description = ''
            Set the syncronisation target settings.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
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
            lib.attrsets.filterAttrs (_n: v: (v != null) && (v != "")) (
              {
                "sync.target" = syncTargetId;
                "locale" = "fr_FR";
              }
              // (optionalAttrs syncEnabled syncSettings)
            )
          );
        in
        entryAfter [ "linkGeneration" ] ''
          # Ensure that settings.json exists.
          mkdir -p '${dirOf configPath}'
          touch '${configPath}'
          # Config has to be written to temporary variable because jq cannot edit files in place.
          config="$(${jq_exe} -s '.[0] + .[1]' '${configPath}' '${newConfig}')"
          printf '%s\n' "''${config}" > '${configPath}'
          unset 'config'
        '';
    };

    programs = {
      joplin-desktop = {
        enable = mkDefault true;
        sync.target = cfg.sync.target;
        sync.interval = cfg.sync.interval;
        extraConfig = mkDefault (
          {
            "editor.codeView" = true;
            "locale" = "fr_FR";
            "ocr.enabled" = false;
            "theme" = 1;
            "themeAutoDetect" = false;
            "markdown.plugin.softbreaks" = false;
            "markdown.plugin.typographer" = false;
            "markdown.plugin.sub" = true;
            "markdown.plugin.sup" = true;
            "markdown.plugin.emoji" = true;
            "markdown.plugin.insert" = true;
            "showTrayIcon" = true;
            "clipperServer.autoStart" = true;
            "spellChecker.languages" = [
              "fr"
              "en-US"
            ];
          }
          // (optionalAttrs syncEnabled syncSettings)
        );
      };
    };
  };
}
