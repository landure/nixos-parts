/**
  # Cava

  Cava is a cross-platform audio visualizer

  ## 🛠️ Tech Stack

  - [Cava homepage](https://github.com/karlstav/cava).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.cava @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.cava.enable).

  ### 🎨 Stylix

  - [cava @ Stylix](https://nix-community.github.io/stylix/options/modules/cava.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.cava;

in
{
  options = {
    biapy.programs.cava.enable = mkEnableOption "cava";
  };

  config = mkIf cfg.enable {
    programs.cava.enable = mkDefault true;
    stylix.targets.cava.rainbow.enable = mkDefault true;
  };
}
