/**
  # SSH

  Default settings for SSH

  ## 🛠️ Tech Stack

  - [OpenSSH homepage](https://www.openssh.org/).
  - [ssh-audit @ GitHub](https://github.com/jtesta/ssh-audit)
    is an SSH server & client configuration auditor.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.ssh](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable).
  - [programs.ssh-agent](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh-agent.enable).

  ## 🙇 Acknowledgements

  - [Temporarily disable ssh public key authentication from client @ serfverfault](https://serverfault.com/questions/493213/temporarily-disable-ssh-public-key-authentication-from-client).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.ssh;
in
{
  options.biapy.programs.ssh.enable = mkEnableOption "ssh";

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = mkDefault true;

      package = mkDefault pkgs.openssh_gssapi;

      # default config is replaced by settings."*"
      enableDefaultConfig = mkDefault false;

      settings."*" = {
        compression = mkDefault true;
        forwardAgent = mkDefault true;
        addKeysToAgent = mkDefault "confirm";

        # ServerAliveInterval = 0;
        # ServerAliveCountMax = 3;
        # HashKnownHosts = false;
        # UserKnownHostsFile "~/.ssh/known_hosts";
        # ControlMaster = false;
        # ControlPath = "~/.ssh/master-%r@%n:%p";
        # ControlPersist = false;
      };
    };

    services.ssh-agent.enable = mkDefault true;

    home.packages = [
      pkgs.ssh-audit
    ]
    ++ (with pkgs.biapy-parts; [
      # Run the very same `ssh` client as the one configured for the `ssh` program.
      (passh.override { openssh = config.programs.ssh.package; })
      (passh-copy-id.override { openssh = config.programs.ssh.package; })
    ]);
  };
}
