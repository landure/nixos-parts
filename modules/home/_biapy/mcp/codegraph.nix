/**
  # CodeGraph

  CodeGraph is a pre-indexed code knowledge graph,
  that auto syncs on code changes.

  ## 🛠️ Tech Stack

  - [CodeGraph homepage](https://colbymchenry.github.io/codegraph/).
  - [CodeGraph @ GitHub](https://github.com/colbymchenry/codegraph).

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
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.biapy.mcp.codegraph;
in
{
  options.biapy.mcp.codegraph = {
    enable = mkEnableOption "CodeGraph";
    package = mkPackageOption pkgs.unstable "codegraph" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.mcp.servers.codegraph = {
      command = mkDefault (getExe cfg.package);
      args = mkDefault [
        "serve"
        "--mcp"
      ];
    };
  };
}
