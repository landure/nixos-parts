/**
  # Foot

  ## 🛠️ Tech Stack

  - [Foot @ Codeberg](https://codeberg.org/dnkl/foot).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.foot @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.enable).
  - [programs.foot @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.foot.).

  ### 🎨 Stylix

  - [foot @ Stylix](https://nix-community.github.io/stylix/options/modules/foot.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.foot;
in
{
  options.biapy.programs.foot.enable = mkEnableOption "foot";

  config = mkIf cfg.enable {
    programs.foot = {
      enable = mkDefault true;
      server.enable = mkDefault true;
      settings = {
        main = {
          dpi-aware = mkDefault "yes";
        };
        mouse = {
          hide-when-typing = mkDefault "yes";
        };
      };
    };
  };
}
