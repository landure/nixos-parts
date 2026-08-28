/**
  # Networking support

  ## 🛠️ Tech Stack

  - [NetworkManager](https://www.networkmanager.dev/).
  - [Connman](https://web.archive.org/web/20210224075615/https://01.org/connman)
    ([Connman @ kernel.org's Git](https://git.kernel.org/pub/scm/network/connman/connman.git/)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [networking @ NixOS reference](https://search.nixos.org/options?query=networking.).

  ## 🙇 Acknowledgements

  - [Connman @ ArchLinux Wiki](https://wiki.archlinux.org/title/ConnMan).
  - [Connman @ Gentoo Wiki](https://wiki.gentoo.org/wiki/Connman).

  - [systemd-networkd @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Systemd/networkd).
  - [systemd-networkd @ ArchLinux Wiki](https://wiki.archlinux.org/title/Systemd-networkd).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr enum;

  detected = config.biapy.facter.detected.networking;
  cfg = config.biapy.networking;

  with_networkmanager = "networkmanager" == cfg.manager;
  with_connman = "connman" == cfg.manager;
  with_networkd = "systemd-networkd" == cfg.manager;

in
{
  options.biapy.networking = {

    enable = mkEnableOption "Networking" // {
      default = detected.enable;
      defaultText = "hardware dependent";
    };

    manager = mkOption {
      type = nullOr (enum [
        "networkmanager"
        "connman"
        "systemd-networkd"
      ]);
      default = null;
      description = "Network management backend to use. null for none (default).";
    };
  };

  config = mkIf cfg.enable {
    biapy.networking = {
      systemd-networkd.enable = mkDefault with_networkd;
      networkmanager.enable = mkDefault with_networkmanager;
    };

    services.connman.enable = mkDefault with_connman;

    networking = {
      dhcpcd.enable = mkDefault true;
      firewall.enable = mkDefault true;
      nftables.enable = mkDefault (!config.virtualisation.docker.enable);
      wireless.enableHardening = mkDefault true;
    };
  };
}
