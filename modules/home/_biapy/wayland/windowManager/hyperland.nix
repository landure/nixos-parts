{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.wayland.windowManager.hyprland;
in
{
  options.biapy.wayland.windowManager.hyprland.enable = mkEnableOption "Hyprland";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = mkDefault true;
      systemd = {
        enable = mkDefault true;
        enableXdgAutostart = mkDefault true;
      };
      configType = mkDefault "lua";
    };

    programs = {
      ashell.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      hyprshot.enable = mkDefault true;
      hyprpanel = {
        enable = mkDefault (!config.services.mako.enable);
      };
    };

    # home.pointerCursor.hyprcursor.enable = mkDefault true;

    services = {
      hypridle = {
        enable = mkDefault true;
        systemdTarget = mkDefault "hyprland-session.target";
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };
          listener = [
            {
              on-timeout = "hyprlock";
              timeout = 900;
            }
            {
              on-resume = "hyprctl dispatch dpms on";
              on-timeout = "hyprctl dispatch dpms off";
              timeout = 1200;
            }
          ];
        };
      };
      hyprlauncher.enable = mkDefault true;
      hyprpaper.enable = mkDefault true;
      hyprshell = {
        enable = mkDefault true;
        systemd.target = mkDefault "hyprland-session.target";
      };
      hyprsunset = {
        enable = mkDefault true;
        systemdTarget = mkDefault "hyprland-session.target";
      };
    };
  };
}
