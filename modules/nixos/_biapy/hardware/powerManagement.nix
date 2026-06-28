/**
  # Laptop power management

  ## 🛠️ Tech Stack

  - [auto-cpufreq @ GitHub](https://github.com/AdnanHodzic/auto-cpufreq).
  - [PowerTOP @ GitHub](https://github.com/fenrus75/powertop).
  - [systemd-logind @ freedesktop.org](https://www.freedesktop.org/software/systemd/man/latest/org.freedesktop.login1.html).
  - [thermal daemon @ GitHub](https://github.com/intel/thermal_daemon).
  - [TLP homepage](https://linrunner.de/tlp/)
    ([TLP @ GitHub](https://github.com/linrunner/TLP)).
  - [TuneD homepage](https://tuned-project.org/)
    ([Tuned @ GitHub](https://github.com/redhat-performance/tuned)).
  - [UPower @ freedesktop.org's GitLab](https://gitlab.freedesktop.org/upower/upower/).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [powerManagement @ NixOS reference](https://search.nixos.org/options?query=powerManagement.).
  - [services.auto-cpufreq @ NixOS reference](https://search.nixos.org/options?query=services.auto-cpufreq).
  - [services.logind @ NixOS reference](https://search.nixos.org/options?query=services.logind.).
  - [services.thermald @ NixOS reference](https://search.nixos.org/options?query=services.thermald).
  - [services.tlp @ NixOS reference](https://search.nixos.org/options?query=services.tlp.).
  - [services.tuned @ NixOS reference](https://search.nixos.org/options?query=services.tuned.).
  - [services.upower @ NixOS reference](https://search.nixos.org/options?query=services.upower.).
  - [networking.networkmanager.wifi.powersave @ NixOS reference](https://search.nixos.org/options?query=networking.networkmanager.wifi.powersave).

  ## 🙇 Acknowledgements

  - [Suspend and then hibernate after 60 minutes @ Matthew Denner's GitHub Gist](https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221).
  - [Laptop @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Laptop).
  - [Power Management @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Power_Management).
  - [Upower : Obtenir des informations sur la batterie et l'alimentation @ Linuxtricks.fr 🇫🇷](https://www.linuxtricks.fr/wiki/upower-obtenir-des-informations-sur-la-batterie-et-l-alimentation).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.hardware.powerManagement;
in
{
  options = {
    biapy.hardware.powerManagement = {
      enable = mkEnableOption "power management" // {
        default = config.biapy.facter.detected.laptop.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = mkDefault true;
      powertop.enable = mkDefault true;
    };

    networking.networkmanager.wifi.powersave = mkDefault true;

    services = {
      auto-cpufreq = {
        enable = mkDefault (!config.services.tuned.enable);
        settings = {
          battery = {
            governor = mkDefault "powersave";
            turbo = mkDefault "never";
          };
          charger = {
            governor = mkDefault "performance";
            turbo = mkDefault "auto";
          };
        };
      };

      logind.settings.Login = {
        HandleLidSwitch = mkDefault "suspend";
        HandleLidSwitchExternalPower = mkDefault "suspend";
        HandleLidSwitchDocked = mkDefault "ignore";
      };

      thermald.enable = mkDefault true;

      tlp = {
        enable = mkDefault (!config.services.tuned.enable);
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = mkDefault "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = mkDefault "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = mkDefault "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = mkDefault "performance";

          CPU_MIN_PERF_ON_AC = mkDefault 0;
          CPU_MAX_PERF_ON_AC = mkDefault 100;
          CPU_MIN_PERF_ON_BAT = mkDefault 0;
          CPU_MAX_PERF_ON_BAT = mkDefault 20;

          # Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = mkDefault 40; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = mkDefault 80; # 80 and above it stops charging
        };
      };

      tuned = {
        enable = mkDefault true;

        settings.dynamic_tuning = mkDefault true;
      };

      upower.enable = mkDefault true;
    };
  };
}
