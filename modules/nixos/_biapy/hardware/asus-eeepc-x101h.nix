/**
  # ASUS eeePC X101H
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (config.hardware.facter.report.smbios.system) manufacturer product;

  cfg = config.biapy.hardware.asus-eeepc-x101h;

  isX101H = manufacturer == "ASUSTeK Computer INC." && product == "X101H";
in
{
  options = {
    biapy.hardware.asus-eeepc-x101h = {
      enable = mkEnableOption "ASUS eeePC X101H support" // {
        default = isX101H;
      };
    };
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        # Local clock is unstable. use global to speed-up boot.
        "trace_clock=global"
      ];

      blacklistedKernelModules = [
        # almost all eeepc_wmi code in now in asus_wmi
        "eeepc_wmi"
      ];
    };

    # Atom processor is unsupported by thermald.
    services.thermald.enable = false;
  };
}
