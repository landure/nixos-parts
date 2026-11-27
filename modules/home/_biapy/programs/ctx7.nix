/**
  # Context7 CLI

  Context7 pulls up-to-date, version-specific documentation
  and code examples straight from the source —
  and places them directly into your prompt.

  ## 🛠️ Tech Stack

  - [Context7 homepage](https://context7.com/).
  - [Context7 @ GitHub](https://github.com/upstash/context7).

  ### 🤖 Agent skills

  - [Context7 skills @ GitHub](https://github.com/upstash/context7/tree/master/skills).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) nameValuePair;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.strings) replaceString;
  inherit (lib.types)
    enum
    listOf
    nullOr
    oneOf
    str
    submodule
    ;
  inherit (pkgs) writeShellApplication;

  cfg = config.biapy.programs.ctx7;

in
{
  options.biapy.programs.ctx7 = {
    enable = mkEnableOption "Context7";
    package = mkPackageOption pkgs "ctx7" { };
    apiKey = mkOption {
      type = nullOr (oneOf [
        str
        submodule
        {
          options = {
            file = mkOption {
              type = str;
              description = ''
                Path to a file whose content is read at startup.
                Compatible with file-based secret managers such as sops-nix
                or systemd credentials.
              '';
            };
          };
        }
      ]);
      default = config.biapy.mcp.context7.apiKey;
      defaultText = "config.biapy.mcp.context7.apiKey";
      description = "CONTEXT7_API_KEY value to raise limits";
    };

    withSkills = mkOption {
      type = listOf (enum [
        "context7-cli"
        "find-docs"
      ]);
      default = [
        "context7-cli"
        "find-docs"
      ];
      description = "Install the context7 CLI agent skills.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.apiKey != null;
        message = "biapy.programs.ctx7.apiKey must be set when biapy.programs.ctx7.enable is true.";
      }
    ];

    home.packages = [
      (writeShellApplication {
        name = "ctx7";
        runtimeInputs = [
          cfg.package
        ];
        text = ''
          CONTEXT7_API_KEY=${cfg.apiKey} exec ${getExe cfg.package} "''${@}"
        '';
      })
    ];

    biapy.ai.skills.skills = builtins.listToAttrs (
      map (
        name:
        nameValuePair name (
          mkDefault (
            replaceString "npx ctx7@latest" "ctx7" "${pkgs.biapy-parts.context7-skills}/skills/${name}"
          )
        )
      ) cfg.withSkills
    );
  };
}
