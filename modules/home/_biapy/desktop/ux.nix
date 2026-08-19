/**
  # User eXperience tools

  ## 🛠️ Tech Stack

  - [Voxtype homepage](https://voxtype.io/)
    ([Voxtype @ GitHub](https://github.com/peteonrails/voxtype)).
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

  cfg = config.biapy.desktop.ux;
in
{
  options = {
    biapy.desktop.ux = {
      enable = mkEnableOption "UX tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      voxtype
    ];
  };
}
