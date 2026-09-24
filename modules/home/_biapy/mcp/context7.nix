/**
  # Context7

  Context7 pulls up-to-date, version-specific documentation
  and code examples straight from the source —
  and places them directly into your prompt.

  ## 🛠️ Tech Stack

  - [Context7 homepage](https://context7.com/).
  - [Context7 @ GitHub](https://github.com/upstash/context7).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.mcp @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.enable).
  - [programs.mcp.servers.<name>. @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.mcp.servers.%3Cname%3E.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types)
    nullOr
    oneOf
    str
    submodule
    ;

  cfg = config.biapy.mcp.context7;
in
{
  options.biapy.mcp.context7 = {
    enable = mkEnableOption "Context7";
    package = mkPackageOption pkgs "context7-mcp" {};
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
      description = "CONTEXT7_API_KEY value to raise limits";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.mcp.servers.context7 = {
      command = mkDefault (getExe cfg.package);
      env = {
        CONTEXT7_API_KEY = mkDefault cfg.apiKey;
      };
    };
  };
}
