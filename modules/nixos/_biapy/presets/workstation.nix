{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.presets.workstation;
in
{
  options.biapy.presets.workstation.enable = mkEnableOption "workstation preset";

  config = mkIf cfg.enable {
    biapy.presets.system.enable = mkDefault true;

    biapy.boot.zswap.enable = mkDefault true;
  };
}
