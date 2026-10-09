/**
  # auto-cpufreq

  Automatic CPU speed & power optimizer for Linux.:
  Actively monitors laptop battery state, CPU usage, CPU temperature,
  and system load,
  ultimately improving battery life without making any compromises.

  ## 🛠️ Tech Stack

  - [auto-cpufreq @ GitHub](https://github.com/AdnanHodzic/auto-cpufreq).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.auto-cpufreq @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.auto-cpufreq.)
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules)
    mkDefault
    mkIf
    ;

  cfg = config.biapy.services.auto-cpufreq;

in
{
  options.biapy.services.auto-cpufreq.enable = mkEnableOption "auto-cpufreq" // {
    default = config.biapy.facter.detected.laptop.enable;
  };

  config = mkIf cfg.enable {
    services.auto-cpufreq = {
      enable = mkDefault true;
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
  };
}
