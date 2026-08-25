/**
  # Screen Backlight control via Facter

  Automatically enables backlight control on laptops detected via facter report.

  ## 🛠️ Tech Stack

  - [brightnessctl @ GitHub](https://github.com/Hummer12007/brightnessctl).

  ## 📝 Documentation

  - [Backlight @ NixOS Wiki](https://wiki.nixos.org/wiki/Backlight).
  - [Backlight @ ArchLinux Wiki](https://wiki.archlinux.org/title/Backlight).

  ## 🙇 Acknowledgements

  - [brightnessctl udev rules](https://github.com/Hummer12007/brightnessctl/blob/master/90-brightnessctl.rules).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  form_factor = (config.hardware.facter.report.hardware.system or { }).form_factor or "";
  is_laptop = form_factor == "laptop";
in
{
  options.biapy.facter.detected.laptop.enable = mkEnableOption "Enable the backlight module" // {
    default = is_laptop;
    defaultText = "hardware dependent";
  };
}
