/**
  # No sleep

  Prevent system from sleeping by disabling related systemd targets.

  Useful for servers.

  ## 📝 Documentation

  - [systemd-sleep.conf, sleep.conf.d -- Suspend and hibernation configuration file @ systemd man pages](https://www.freedesktop.org/software/systemd/man/247/systemd-sleep.conf.html).

  ## 🙇 Acknowledgements

  - [How to disable suspend on Ubuntu 20.04 (systemd) via CLI @ serverfault](https://serverfault.com/questions/1045949/how-to-disable-suspend-on-ubuntu-20-04-systemd-via-cli).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.system.no-sleep;
in
{
  options.biapy.system.no-sleep.enable = mkEnableOption "No sleep mode";

  config = mkIf cfg.enable {
    services.logind.settings.Login = {
      HandleSuspendKey = "ignore";
      HandleHibernateKey = "ignore";
      HandleLidSwitch = mkDefault "ignore";
      HandleLidSwitchExternalPower = mkDefault "ignore";
      HandleLidSwitchDocked = mkDefault "ignore";
    };

    systemd.sleep.extraConfig = lib.strings.concatStringsSep "\n" [
      "AllowSuspend=no"
      "AllowHibernation=no"
      "AllowSuspendThenHibernate=no"
      "AllowHybridSleep=no"
    ];
  };
}
