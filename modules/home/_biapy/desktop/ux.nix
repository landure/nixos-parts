/**
  # User eXperience tools
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.desktop.ux;
in
{
  options.biapy.desktop.ux.enable = mkEnableOption "UX tools";

  config = mkIf cfg.enable {
    biapy.services.handy.enable = mkDefault true;
  };
}
