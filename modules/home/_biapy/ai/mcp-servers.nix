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
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.ai.mcp-servers;

in
{
  options = {
    biapy.ai.mcp-servers.enable = mkEnableOption "MCP servers";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mcp-nixos
      mcp-server-git
      mcp-server-fetch
      mcp-server-filesystem
      mcp-language-server
      context7-mcp
    ];
  };
}
