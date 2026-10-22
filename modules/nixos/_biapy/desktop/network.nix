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
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.desktop.network;
in
{
  options.biapy.desktop.network.enable = mkEnableOption "network tools";

  config = mkIf cfg.enable {
    programs.sniffnet.enable = mkDefault true;
  };
}
