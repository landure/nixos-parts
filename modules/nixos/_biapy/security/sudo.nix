/**
  # sudo

  Sudo (su “do”) allows a system administrator to delegate authority to give
  certain users (or groups of users) the ability to run some (or all) commands
  as root or another user while providing an audit trail of the commands
  and their arguments.

  - [sudo homepage](https://www.sudo.ws/)
    ([sudo @ GitHub](https://github.com/sudo-project/sudo)).
  - [security.sudo @ NixOS reference](https://search.nixos.org/options?query=security.sudo)
  - [security.pam.services.*.sshAgentAuth @ NixOS reference](https://search.nixos.org/options?query=security.pam.services.%3Cname%3E.sshAgentAuth)
  - [nix.settings.extra-trusted-users @ NixOS reference](https://search.nixos.org/options?query=nix.settings.extra-trusted-users)
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
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;

  cfg = config.biapy.security.sudo;

in
{
  options = {
    biapy.security.sudo.enable = mkOption {
      type = bool;
      default = true;
      example = true;
      description = ''
        Whether to add default sudo configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups.wheel.members = attrNames config.home-manager.users;

    # Enable sudo for users in wheel group, and allow sudoers reboot and poweroff
    # @see https://nixos.wiki/wiki/Sudo
    security.sudo-rs = {
      enable = mkDefault true;
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

    security.pam.services.sudo.sshAgentAuth = mkDefault true;

    # Allow sudoers to run nix commands without password and apply remote builds
    nix.settings.extra-trusted-users = [ "@wheel" ];
  };
}
