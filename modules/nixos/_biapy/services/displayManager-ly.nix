/**
  # ly display manager

  ## 🛠️ Tech Stack

  - [ly @ Codeberg](https://codeberg.org/fairyglade/ly).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.displayManager.ly @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.ly.)

  ## 🙇 Acknowledgements

  - [ly's config.ini @ ly's GitHub](https://github.com/fairyglade/ly/blob/master/res/config.ini).
*/
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) getExe;
  inherit (lib.modules)
    mkDefault
    mkIf
    ;
  inherit (pkgs) brightnessctl;

  cfg = config.biapy.services.displayManager.ly;

  has_brightness = config.biapy.hardware.backlight.enable;
  brightnessctlCommand = getExe brightnessctl;
in
{
  options = {
    biapy.services.displayManager.ly.enable = mkEnableOption "ly greeter";
  };

  config = mkIf cfg.enable {
    services.displayManager.ly = {
      enable = mkDefault true;
      x11Support = mkDefault false;
      settings = {
        # The active animation
        # none     -> Nothing
        # doom     -> PSX DOOM fire
        # matrix   -> CMatrix
        # colormix -> Color mixing shader
        # gameoflife -> John Conway's Game of Life
        # dur_file -> .dur file format (https://github.com/cmang/durdraw/tree/master)
        animation = mkDefault "matrix";

        # Allow empty password or not when authenticating
        allow_empty_password = mkDefault false;

        # The number of failed authentications before a special animation is played... ;)
        # If set to 0, the animation will never be played
        auth_fails = mkDefault 3;

        # Change the state and language of the big clock
        # none -> Disabled (default)
        # en   -> English
        # fa   -> Farsi
        bigclock = mkDefault "en";
        lang = mkDefault "fr";

        # Brightness decrease command
        brightness_down_cmd = mkDefault (
          if has_brightness then "${brightnessctlCommand} --quiet --min-value set '10%-'" else null
        );

        # Brightness decrease key combination, or null to disable
        brightness_down_key = mkDefault (if has_brightness then "F5" else null);

        # Brightness increase command
        brightness_up_cmd = mkDefault (
          if has_brightness then "${brightnessctlCommand} --quiet --min-value set '+10%'" else null
        );

        # Brightness increase key combination, or null to disable
        brightness_up_key = mkDefault (if has_brightness then "F6" else null);
      };
    };
  };
}
