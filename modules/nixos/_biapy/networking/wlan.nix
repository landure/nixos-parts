/**
  # Wireless support

  #### Iwd

  - [iwd: Wireless daemon for Linux](https://git.kernel.org/pub/scm/network/wireless/iwd.git/about/).
  - [impala @ GitHub](https://github.com/pythops/impala).

  #### wpa_supplicant

  - [Linux WPA/WPA2/WPA3/IEEE 802.1X Supplicant homepage](https://w1.fi/wpa_supplicant/).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [networking.wireless.iwd @ NixOS reference](https://search.nixos.org/options?query=networking.wireless.iwd.).

  ## 🙇 Acknowledgements

  - [iwd @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Iwd).
  - [iwd @ ArchLinux Wiki](https://wiki.archlinux.org/title/Iwd#Enable_built-in_network_configuration).
  - [iwd @ Gentoo Wiki](https://wiki.gentoo.org/wiki/Iwd).

  - [wpa_supplicant @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Wpa_supplicant).
  - [wpa_supplicant @ ArchLinux Wiki](https://wiki.archlinux.org/title/Wpa_supplicant).
  - [wpa_supplicant @ Gentoo Wiki](https://wiki.gentoo.org/wiki/Wpa_supplicant).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) optional;
  inherit (lib.modules)
    mkDefault
    mkIf
    mkOptionDefault
    ;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;

  detected = config.biapy.facter.detected.networking;
  cfg = config.biapy.networking.wireless;

  with_wpa_supplicant = "wpa_supplicant" == cfg.backend;
  with_iwd = "iwd" == cfg.backend;
in
{
  options.biapy.networking.wireless = {
    enable = mkEnableOption "Wireless networking (WiFi)" // {
      default = detected.wlan.enable;
      defaultText = "hardware dependent";
    };

    backend = mkOption {
      type = enum [
        "iwd"
        "wpa_supplicant"
      ];
      default = "iwd";
      description = "Wireless backend to use for WLAN connections";
    };
  };

  config = mkIf cfg.enable {
    environment.defaultPackages =
      (optional config.networking.wireless.iwd.enable pkgs.impala)
      ++ (optional config.networking.networkmanager.enable pkgs.wifitui);

    services.connman.wifi.backend = mkDefault cfg.backend;

    networking = {
      networkmanager.wifi.backend = mkDefault cfg.backend;

      wireless = {
        enable = mkDefault with_wpa_supplicant;
        enableHardening = mkDefault true;
        userControlled = mkDefault true;

        iwd = {
          enable = mkDefault with_iwd;
          settings = mkDefault {
            General = {
              EnableNetworkConfiguration = mkOptionDefault true;

              # increase the threshold to allow a worse connection (min is -100, max is 1).
              # RoamThreshold defaults to -70 and RoamThreshold5G to -76.
              # RoamThreshold = mkOptionDefault (-75);
              # RoamThreshold5G = mkOptionDefault (-80);
              # CriticalRoamThreshold = mkOptionDefault (-80);
              # CriticalRoamThreshold5G = mkOptionDefault (-82);

              # MAC address randomization: disabled, once, network
              # set to once to supports iPhone hotspots
              # AddressRandomization = mkOptionDefault "once";
            };
            Network = {
              EnableIPv6 = mkOptionDefault true;
              # resolvconf, systemd, none
              # NameResolvingService = mkOptionDefault "systemd";
            };

            # DriverQuirks = {
            #   PowerSaveDisable = mkOptionDefault (lib.strings.concatStringsSep "," []);
            # };
          };
        };
      };
    };
  };
}
