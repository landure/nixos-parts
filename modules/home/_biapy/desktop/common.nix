/**
  # Desktop environment common settings

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [systemd.user.enable @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-systemd.user.enable).
  - [systemd.user.targets @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-systemd.user.targets).
  - [systemd.user @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=systemd.user.).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.desktop.common;
in
{
  options = {
    biapy.desktop.common = {
      enable = mkEnableOption "Desktop environment common settings";
    };
  };

  config = mkIf cfg.enable {
    # User custom systemd targets.
    # Add tray target for tray icons (flameshot, …)
    systemd.user.targets.tray.Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
