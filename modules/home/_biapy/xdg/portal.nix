/**
  # XDG Desktop Portal

  Portal is frontend service for Flatpak
  and other desktop containment frameworks.

  `xdg-desktop-portal` exposes a series of D-Bus interfaces known as portals
  under a well-known name (`org.freedesktop.portal.Desktop`)
  and object path (`/org/freedesktop/portal/desktop`).

  ## 🛠️ Tech Stack

  - [XDG Desktop Portal homepage](https://flatpak.github.io/xdg-desktop-portal/)
    ([XDG Desktop Portal @ GitHub](https://github.com/flatpak/xdg-desktop-portal/)).

  ### 🧩 Portal Backends

  - [xdg-desktop-portal-gnome @ GNOME's GitLab](https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome).
  - [xdg-desktop-portal-gtk @ GitHub](https://github.com/flatpak/xdg-desktop-portal-gtk).
  - [xdg-desktop-portal-wlr @ GitHub](https://github.com/emersion/xdg-desktop-portal-wlr).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [xdg.portal @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.portal.enable).
  - [xdg.portal @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=xdg.portal.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.desktop.xdg.portal;
in
{
  options.biapy.desktop.xdg.portal.enable = mkEnableOption "XDG desktop portal";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = mkDefault true;

      # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
      # This will make xdg-open use the portal to open programs,
      # which resolves bugs involving programs opening inside FHS envs
      # or with unexpected env vars set from wrappers.
      xdgOpenUsePortal = mkDefault true;

      # Sets which portal backend should be used to provide the implementation
      # for the requested interface. For details check portals.conf(5).
      # These will be written with the name $desktop-portals.conf
      # for xdg.portal.config.$desktop and portals.conf for
      # xdg.portal.config.common as an exception.
      config = {
        common = {
          default = mkDefault [ "gtk" ];
        };

        gnome = {
          default = mkDefault [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Access" = mkDefault [
            "gnome-shell"
            "gtk"
          ];
        };
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };
}
