/**
  # Networking detection

  Set `config.biapy.facter.detected.networking.enable` and `config.biapy.facter.detected.networking.wlan.enable`
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  network_controllers = config.hardware.facter.report.hardware.network_controller or [ ];

  # Filter WLAN network controllers from facter report
  wlan_interfaces = lib.filter (
    controller: controller.sub_class.name == "WLAN controller"
  ) network_controllers;

in
{
  options.biapy.facter.detected.networking = {
    enable = mkEnableOption "Facter Networking module" // {
      default = builtins.length network_controllers > 0;
      defaultText = "hardware dependent";
    };

    wlan.enable = mkEnableOption "Facter WLAN module" // {
      default = builtins.length wlan_interfaces > 0;
      defaultText = "hardware dependent";
    };
  };
}
