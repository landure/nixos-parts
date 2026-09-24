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
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.mcp.codegraph;
in
{
  options.biapy.mcp.codegraph.enable = mkEnableOption "CodeGraph";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ unstable.codegraph ];

    programs.mcp.servers.codegraph = {
      command = mkDefault "codegraph";
      args = mkDefault [
        "serve"
        "--mcp"
      ];
    };
  };
}
