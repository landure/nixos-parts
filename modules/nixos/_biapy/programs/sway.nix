/**
  # Sway

  ## 📝 Documentation

  - [environment.sessionVariables @ NixOS reference](https://search.nixos.org/options?query=environment.sessionVariables).
  - [services.libinput @ NixOS reference](https://search.nixos.org/options?query=services.libinput.).
  - [programs.sway @ NixOS reference](https://search.nixos.org/options?query=programs.sway.).
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

  cfg = config.biapy.programs.sway;
in
{
  options.biapy.programs.sway.enable = mkEnableOption "Sway tiling compositor";

  config = mkIf cfg.enable {
    biapy = {
      xdg.portal.enable = mkDefault true;
      programs = {
        foot.enable = mkDefault true;
        grim.enable = mkDefault true;
        sway.enable = mkDefault true;
      };
    };

    programs.sway = {
      enable = mkDefault true;
      wrapperFeatures.gtk = mkDefault true;
      extraPackages = with pkgs; [
        swayidle
        swaylock
        wmenu
        dmenu-rs
        fuzzel
        nerd-fonts.hack
        noto-fonts
        qutebrowser
      ];
    };

    # Enable XDG Portal wayland-root integration
    xdg.portal.wlr.enable = mkDefault true;

  };
}
