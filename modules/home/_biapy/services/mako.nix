/**
  # Mako

  lightweight notification daemon for Wayland .

  ## 🛠️ Tech Stack

  @see https://github.com/emersion/mako
  @see https://nix-community.github.io/home-manager/options.xhtml#opt-services.mako.enable

  ## 📝 Documentation

  - [configuration file @ mako documentation](https://github.com/emersion/mako/blob/master/doc/mako.5.scd).

  ### 🏠 Home Manager

  - [services.mako @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/services/mako.html).
  - [services.mako @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.mako.).

  ### 🎨 Stylix

  - [mako @ Stylix](https://nix-community.github.io/stylix/options/modules/mako.html).

  ## 🙇 Acknowledgements

  - [Sway WM: Notifications with Mako @ Lorenzo Bettini](https://www.lorenzobettini.it/2024/11/sway-wm-notifications-with-mako/).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.services.mako;
in
{
  options.biapy.services.mako.enable = mkEnableOption "mako notification daemon service";

  config = mkIf cfg.enable {
    services.mako = {
      enable = mkDefault true;

      settings = {
        "actionable=true".anchor = mkDefault "top-left";
        actions = mkDefault true;
        anchor = mkDefault "top-right";
        ignore-timeout = mkDefault false;
        icons = mkDefault true;
        layer = mkDefault "top";
        markup = mkDefault true;
        #   background-color = "#000000";
        #   border-color = "#FFFFFF";
        #   border-radius = 0;
        #   default-timeout = 0;
        #   font = "monospace 10";
        #   height = 100;
        #   margin = 10;
        #   width = 300;
      };
    };
  };
}
