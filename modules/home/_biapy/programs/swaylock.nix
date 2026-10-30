/**
  # SwayLock

  swaylock is a screen locking utility for Wayland compositors.

  `swaylock` use PAM.
  Debian-based system patch PAM to support `@include` configuration
  directive.
  Nix's PAM package doesn't support `@include`.
  This results in errors preventing the unlocking of `swaylock`.

  ❗ On Debian system, install the Operating System `swaylock` package:

  ```bash
  sudo apt install 'swaylock'
  ```

  and configure `services.swayidle` to use `/usr/bin/swaylock` binary
  to run `swaylock`.

  ## 🛠️ Tech Stack

  - [swaylock @ GitHub](https://github.com/swaywm/swaylock).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.swaylock @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/swaylock.html).
  - [programs.swaylock @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.swaylock.).

  ### 🎨 Stylix

  - [swaylock @ Stylix](https://nix-community.github.io/stylix/options/modules/swaylock.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  genericLinuxSwaylockBinary = "/usr/bin/swaylock";

  cfg = config.biapy.programs.swaylock;
in
{
  options.biapy.programs.swaylock = {
    enable = mkEnableOption "swaylock";

    binary = mkOption {
      type = str;
      default = genericLinuxSwaylockBinary;
      description = ''
        swaylock binary path (read-only)
      '';
      apply =
        _:
        if config.targets.genericLinux.enable then
          genericLinuxSwaylockBinary
        else
          (getExe config.programs.swaylock.package);
    };
  };

  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = mkDefault true;
      package = mkDefault (if config.targets.genericLinux.enable then null else pkgs.swaylock);
      settings = {
        # color = "808080";
        # font-size = 24;
        indicator-idle-visible = mkDefault false;
        indicator-radius = mkDefault 100;
        # line-color = "ffffff";
        show-failed-attempts = mkDefault true;
        show-keyboard-layout = mkDefault true;
        indicator-caps-lock = mkDefault true;
        ignore-empty-password = mkDefault true;
      };
    };
  };
}
