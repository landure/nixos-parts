/**
  # Desktop Graphics tools
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.desktop.graphics;
in
{
  options.biapy.desktop.graphics.enable = mkEnableOption "Desktop graphics tools";

  config = mkIf cfg.enable {
    biapy.services.flameshot.enable = mkDefault true;
  };
}
