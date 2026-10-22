/**
  # Network tools for desktop environments.

  ## 🛠️ Tech Stack

  - [Sniffnet homepage](https://sniffnet.net/)
    [Sniffnet @ GitHub](https://github.com/gyulyvgc/sniffnet)
    is an application to comfortably monitor your network traffic.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.desktop.network;
in
{
  options.biapy.desktop.network.enable = mkEnableOption "network tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sniffnet
    ];
  };
}
