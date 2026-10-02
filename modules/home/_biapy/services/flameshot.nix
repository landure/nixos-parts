/**
  # Flameshot

  ## 🛠️ Tech Stack

  - [Flameshot homepage](https://flameshot.org/).
  - [Flameshot @ GitHub](https://github.com/flameshot-org/flameshot).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [services.flameshot @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.flameshot.enable).
  - [services.flameshot @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.flameshot.).

  ## 🙇 Acknowledgements

  - [Flameshot @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Flameshot).
  - [Screen capture @ Arch Linux Wiki](https://wiki.archlinux.org/title/Screen_capture).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.services.flameshot;

in
{
  options.biapy.services.flameshot.enable = mkEnableOption "Flameshot service";

  config = mkIf cfg.enable {
    biapy.desktop.xdg.portal.enable = mkDefault true;

    services.flameshot = {
      enable = mkDefault true;
      settings = {
        General = {
          # disabledTrayIcon = true;
          showStartupLaunchMessage = mkDefault false;

          # Stops warnings for using Grim
          disabledGrimWarning = mkDefault true;
          # For Wayland (Install Grim seperately)
          useGrimAdapter = mkDefault true;

          # Default file extension for screenshots (.png by default)
          saveAsFileExtension = mkDefault ".png";
          # Desktop notifications
          showDesktopNotification = mkDefault true;
          # Notification for cancelled screenshot
          showAbortNotification = mkDefault false;

          # Whether to show the info panel in the center in GUI mode
          showHelp = mkDefault true;
          # Whether to show the left side button in GUI mode
          showSidePanelButton = mkDefault true;
          # Whether to enable legacy (pre-xdg-desktop-portal) screenshotting on X11
          useX11LegacyScreenshot = mkDefault false;
        };
      };
    };

    wayland.windowManager.sway.config =
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
      {
        keybindings = {
          # Manual screenshot GUI that saves to clipboard and closes on selection.
          "${modifier}+Shift+s" = mkDefault "exec flameshot gui --clipboard --accept-on-select";
          # Takes a screenshot of the screen containing the cursor.
          "${modifier}+Shift+a" = mkDefault "exec flameshot screen --clipboard";
          # Takes a manual screenshot that shows options after selection.
          "Print" = mkDefault "exec flameshot gui";
        };
      };
  };
}
