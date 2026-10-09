/**
  # Polkit

  polkit is an application-level toolkit for defining and handling the policy
  that allows unprivileged processes to speak to privileged processes:
  It is a framework for centralizing the decision making process with respect
  to granting access to privileged operations for unprivileged applications.

  ## 🛠️ Tech Stack

  - [Polkit @ freeDesktop](https://polkit.pages.freedesktop.org/polkit/).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [security.polkit @ NixOS reference](https://search.nixos.org/options?query=security.polkit.).

  ## 🙇 Acknowledgements

  - [Polkit @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Polkit).
  - [Polkit @ ArchLinux Wiki](https://wiki.archlinux.org/title/Polkit).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.security.polkit;

in
{
  options.biapy.security.polkit.enable = mkEnableOption "polkit";

  config = mkIf cfg.enable {
    security.polkit = {
      enable = mkDefault true;
      # adminIdentities = [ "unix-group:wheel" ];
      # grant the permissions reboot and poweroff a machine to users in the users group.
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };
}
