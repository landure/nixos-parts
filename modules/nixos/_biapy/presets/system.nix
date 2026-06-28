{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.presets.system;
in
{
  options.biapy.presets.system.enable = mkEnableOption "Base system preset";

  config = mkIf cfg.enable {
    biapy.networking.ntp.enable = mkDefault true;

    biapy.services.kmscon.enable = mkDefault true;
  };
}
