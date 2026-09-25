/**
  # MCP servers

  ## 🛠️ Tech Stack

  - [MCP Language Server @ GitHub](https://github.com/isaacphi/mcp-language-server).
  - [MCP-NixOS homepage](https://mcp-nixos.io/).
    ([MCP-NixOS @ GitHub](https://github.com/utensils/mcp-nixos)).
  - [Model Context Protocol servers @ GitHub](https://github.com/modelcontextprotocol/servers).
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

  cfg = config.biapy.ai.mcp-servers;

in
{
  options = {
    biapy.ai.mcp-servers.enable = mkEnableOption "MCP servers";
  };

  config = mkIf cfg.enable {
    biapy = {
      mcp = {
        codegraph.enable = mkDefault true;
        context7.enable = mkDefault true;
      };

      programs.rtk.enable = mkDefault true;
    };

    programs.mcp.enable = mkDefault true;

    home.packages = with pkgs; [
      mcp-nixos
      mcp-server-git
      mcp-server-fetch
      mcp-server-filesystem
      mcp-language-server
    ];
  };
}
