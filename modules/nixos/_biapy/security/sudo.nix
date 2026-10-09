/**
  # sudo

  Sudo (su “do”) allows a system administrator to delegate authority to give
  certain users (or groups of users) the ability to run some (or all) commands
  as root or another user while providing an audit trail of the commands
  and their arguments.

  ## 🛠️ Tech Stack

  - [sudo homepage](https://www.sudo.ws/)
    ([sudo @ GitHub](https://github.com/sudo-project/sudo)).
  - [sudo-rs @ Trifecta Tech Foundation](https://trifectatech.org/projects/sudo-rs/)
    ([sudo-rs @ GitHub](https://github.com/trifectatechfoundation/sudo-rs)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [nix.settings.extra-trusted-users @ NixOS reference](https://search.nixos.org/options?query=nix.settings.extra-trusted-users).
  - [security.sudo @ NixOS reference](https://search.nixos.org/options?query=security.sudo.).
  - [security.sudo-rs @ NixOS reference](https://search.nixos.org/options?query=security.sudo-rs.).
  - [security.pam.services.*.sshAgentAuth @ NixOS reference](https://search.nixos.org/options?query=security.pam.services.%3Cname%3E.sshAgentAuth).
  - [security.polkit.adminIdentities @ NixOS reference](https://search.nixos.org/options?query=security.polkit.adminIdentities).

  ## 🙇 Acknowledgements

  - [Sudo @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Sudo).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) attrNames;
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.security.sudo;

in
{
  options.biapy.security.sudo.enable = mkEnableOption "sudo" // {
    default = true;
  };

  config = mkIf cfg.enable {
    users.groups.wheel.members = attrNames config.home-manager.users;

    # Allow sudoers to run nix commands without password and apply remote builds
    nix.settings.extra-trusted-users = [ "@wheel" ];

    security = {
      pam.services.sudo.sshAgentAuth = mkDefault true;

      polkit.adminIdentities = [ "unix-group:wheel" ];

      sudo-rs = {
        enable = mkDefault true;
        execWheelOnly = mkDefault true;
        # allow sudoers reboot and poweroff
        extraRules = [
          {
            commands = [
              {
                command = "${getExe' pkgs.systemd "systemctl"} suspend";
                options = [ "NOPASSWD" ];
              }
              {
                command = getExe' pkgs.systemd "reboot";
                options = [ "NOPASSWD" ];
              }
              {
                command = getExe' pkgs.systemd "poweroff";
                options = [ "NOPASSWD" ];
              }

              # Allow passwordless use of nixos-rebuild switch --use-remote-sudo --target-host "user@host"
              {
                command = "${getExe' pkgs.nix "nix-env"} -p /nix/var/nix/profiles/system --set /nix/store/*nixos-system*";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };
    };
  };
}
