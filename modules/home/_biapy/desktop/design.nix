/**
  # Design tools

  ## 🛠️ Tech Stack

  - [GIMP homepage](https://www.gimp.org/).
  - [Inkscape homepage](https://inkscape.org/).
  - [Krita homepage](https://krita.org/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.desktop.design;
in
{
  options.biapy.desktop.design.enable = mkEnableOption "design tools";

  config = mkIf cfg.enable {
    biapy.desktop.graphics.enable = mkDefault true;

    home.packages = with pkgs; [
      gimp # Image edition GUI
      inkscape # SVG editor
      krita
    ];
  };
}
