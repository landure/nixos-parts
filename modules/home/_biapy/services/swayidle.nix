/**
  # SwayLock & SwayIdle

  swayidle is Sway's idle management daemon.
  swaylock is a screen locking utility for Wayland compositors.

  `swaylock` use `pam`.
  Debian-based system patch `pam` to support `@include` configuration
  directive.
  Nix's `pam` package doesn't support `@include`.
  This results in errors preventing the unlocking of `swaylock`.

  ❗ On Debian system, install the Operating System `swaylock` package:

  ```bash
  sudo apt install 'swaylock'
  ```

  and configure `services.swayidle` to use `/usr/bin/swaylock` binary
  to run `swaylock`.

  ## 🛠️ Tech Stack

  - [swayidle @ GitHub](https://github.com/swaywm/swayidle).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [services.swayidle @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/services/swayidle.html).
  - [services.swayidle @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.swayidle.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.services.swayidle;
  swaylockCommand = config.biapy.programs.swaylock.binary;
in
{
  options.biapy.services.swayidle.enable = mkEnableOption "swayidle service";

  config = mkIf cfg.enable {
    biapy.programs.swaylock.enable = mkDefault true;

    services.swayidle = {
      enable = mkDefault true;

      events = {
        before-sleep = mkDefault "${swaylockCommand} --daemonize --show-failed-attempts";
        lock = mkDefault "lock";
      };

      timeouts = [
        {
          timeout = mkDefault 600;
          command = mkDefault "${swaylockCommand} --daemonize --show-failed-attempts";
        }
        {
          timeout = mkDefault 900;
          command = mkDefault "systemctl suspend";
        }
      ];

      systemdTargets = [ "sway-session.target" ];
    };

    wayland.windowManager.sway.config.startup = [
      {
        command = "systemctl --user restart swayidle.service";
        always = true;
      }
    ];
  };
}
