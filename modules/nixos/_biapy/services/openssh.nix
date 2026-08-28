/**
  # OpenSSH

  ## 🛠️ Tech Stack

  - [OpenSSH homepage](https://www.openssh.org/).
  - [fail2ban @ GitHub](https://github.com/fail2ban/fail2ban ).
  - [SSH @ Official NixOS Wiki](https://wiki.nixos.org/wiki/SSH).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.openssh @ NixOS reference](https://search.nixos.org/options?show=services.openssh.).
  - [services.fail2ban @ NixOS reference](https://search.nixos.org/options?show=services.fail2ban.).
  - [environment.etc @ NixOS reference](https://search.nixos.org/options?show=environment.etc).
  - [users.groups @ NixOS reference](https://search.nixos.org/options?show=users.groups.).
  - [security.pam.sshAgentAuth @ NixOS reference](https://search.nixos.org/options?query=security.pam.sshAgentAuth.).
*/
{ config, lib, ... }:
let
  inherit (lib.attrsets) attrNames mapAttrs;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption ;
  inherit (lib.types)
    str
    # path
    # nullOr
    # submodule
    ;

  cfg = config.biapy.services.openssh;
in
{
  options = {
    biapy.services.openssh = {
      enable = mkEnableOption "OpenSSH server, with fail2ban" // {
        default = true;
      };

      allowedGroup = mkOption {
        type = str;
        default = "ssh-users";
        description = "Group which users are allowed to connect to the host by using SSH";
      };

      # ed25519_key = mkOption {
      #   type = nullOr (submodule {
      #     options = {
      #       private_key = mkOption {
      #         type = path;
      #         description = ''
      #           Content of the ED25519 private key to install in /etc/ssh/ssh_host_ed25519_key.
      #         '';
      #       };
      #       public_key = mkOption {
      #         type = path;
      #         description = ''
      #           Content of the ED25519 public key to install in /etc/ssh/ssh_host_ed25519_key.pub.
      #         '';
      #       };
      #     };
      #   });
      #   default = null;
      #   description = ''
      #     Optional ED25519 host key configuration. When set, installs the private and public keys to /etc/ssh.
      #   '';
      # };

    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.allowedGroup}.members = mkDefault (attrNames  config.home-manager.users);

    # sops.secrets = {
    #   "openssh/private_key" = {
    #     mode = "0600";
    #     owner = config.users.users.root.name;
    #     inherit (config.users.users.root) group;
    #     # path = "/etc/ssh/ssh_host_ed25519_key"
    #   };
    #   "openssh/public_key" = {
    #     mode = "0644";
    #     owner = config.users.users.root.name;
    #     inherit (config.users.users.root) group;
    #     # path = "/etc/ssh/ssh_host_ed25519_key.pub"
    #   };
    # };

    # systemd.services.sshd-keygen.after = [ "sops-nix.service" ];

    # environment.etc = mkIf (cfg.ed25519_key != null) {
    #   "ssh/ssh_host_ed25519_key" = {
    #     source = config.sops.secrets."openssh/private_key".path;
    #     mode = "0600";
    #     uid = 0;
    #     gid = 0;
    #   };
    #   "ssh/ssh_host_ed25519_key.pub" = {
    #     source = config.sops.secrets."openssh/public_key".path;
    #     mode = "0644";
    #     uid = 0;
    #     gid = 0;
    #   };
    # };

    # Allow SSH Agent authentication.
    security.pam.sshAgentAuth.enable = mkDefault true;

    services = {
      # userborn.enable = true;
      openssh = {
        enable = mkDefault true;

        authorizedKeysInHomedir = mkDefault true;

        settings = mkDefault {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          AllowGroups = [cfg.allowedGroup  ];
        };

        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };

      fail2ban.enable = mkDefault true;
    };
  };
}
