/**
  # TLP

  TLP is a feature-rich Linux utility designed to save laptop battery power.

  ## 🛠️ Tech Stack

  - [TLP homepage](https://linrunner.de/tlp/)
    ([TLP @ GitHub](https://github.com/linrunner/TLP)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.tlp @ NixOS reference](https://search.nixos.org/options?query=services.tlp.).
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

  cfg = config.biapy.services.tlp;

in
{
  options.biapy.services.tlp.enable = mkEnableOption "TLP" // {
    default = config.biapy.facter.detected.laptop.enable;
  };

  config = mkIf cfg.enable {
    services.tlp = {
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
  };
}
