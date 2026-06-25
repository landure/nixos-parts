/**
  # SSH

  Default settings for SSH

  ## 🛠️ Tech Stack

  - [OpenSSH homepage](https://www.openssh.org/).

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
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.ssh;

  ssh_exe = getExe pkgs.openssh;
  ssh-copy-id_exe = getExe' pkgs.openssh "ssh-copy-id";
in
{
  options = {
    biapy.programs.ssh = {
      enable = mkEnableOption "ssh";
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = mkDefault true;

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
      (pkgs.writeShellScriptBin "passh" ''
        # ssh with public key authentication turned off
        # see https://serverfault.com/questions/493213/temporarily-disable-ssh-public-key-authentication-from-client

        ${ssh_exe} -o 'PreferredAuthentications=password' -o 'PubkeyAuthentication=no' "''${@}"
      '')
      (pkgs.writeShellScriptBin "passh-copy-id" ''
        # ssh-copy-id with public key authentication turned off
        # see https://serverfault.com/questions/493213/temporarily-disable-ssh-public-key-authentication-from-client

        ${ssh-copy-id_exe} -o 'PreferredAuthentications=password' -o 'PubkeyAuthentication=no' "''${@}"
      '')
    ];
  };
}
