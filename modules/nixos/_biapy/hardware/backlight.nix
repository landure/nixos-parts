/**
  # Screen Backlight control

  ## 🛠️ Tech Stack

  - [brightnessctl @ GitHub](https://github.com/Hummer12007/brightnessctl).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [programs.light @ NixOS reference](https://search.nixos.org/options?query=programs.light.).
  - [services.actkbd @ NixOS reference](https://search.nixos.org/options?query=services.actkbd.).
  - [services.udev.packages @ NixOS reference](https://search.nixos.org/options?query=services.udev.packages).

  ## 🙇 Acknowledgements

  - [Backlight @ NixOS Wiki](https://wiki.nixos.org/wiki/Backlight).
  - [Backlight @ ArchLinux Wiki](https://wiki.archlinux.org/title/Backlight).
  - [brightnessctl udev rules @ GitHub](https://github.com/Hummer12007/brightnessctl/blob/master/90-brightnessctl.rules).
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

  cfg = config.biapy.hardware.backlight;
in
{
  options = {
    biapy.hardware.backlight = {
      enable = mkEnableOption "Screen backlight control" // {
        default = config.biapy.facter.detected.laptop.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.brightnessctl ];

    # Install brightnessctl udev rules, allowing members of the video group
    # to change backlight brightness without root privileges.
    services.udev.packages = [ pkgs.brightnessctl ];

    users = {
      # Create video and input groups, since they're mentionned in
      groups = {
        video = { };
        input = { };
      };

      # Add the main user to the video group so they can use brightnessctl.
      # users."${config.biapy.nixos-unified.nixos.main-user}".extraGroups = [ "video" ];
    };

    # Light is deprecated (?)
    # programs.light.enable = mkDefault true;
  };
}
