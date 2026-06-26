/**
  # NTP client

  Configure the system's NTP client with French & European servers.

  ## 🛠️ Tech Stack

  - [Network Time Protocol (NTP)](https://www.ntp.org/).
  - [systemd-timesyncd @ freedesktop.org](https://www.freedesktop.org/software/systemd/man/latest/systemd-timesyncd)
  - [ntpd-rs](https://docs.ntpd-rs.pendulum-project.org/)
    ([ntpd-rs @ GitHub](https://github.com/pendulum-project/ntpd-rs)).
  - [OpenNTPD](https://www.openntpd.org/)
    ([OpenNTPD @ GitHub](https://github.com/openntpd-portable)).
  - [Chrony](https://chrony-project.org/)
    ([Chrony @ GitLab](https://gitlab.com/chrony/chrony))

  ## 📝 Documentation

  ### ❄️ NixOS

  - [networking.timeServers @ NixOS reference](https://search.nixos.org/options?query=networking.timeServers).
  - [services.timesyncd @ NixOS reference](https://search.nixos.org/options?query=services.timesyncd.).
  - [services.ntp @ NixOS reference](https://search.nixos.org/options?query=services.ntp.).
  - [services.ntp-rs @ NixOS reference](https://search.nixos.org/options?query=services.ntp-rs.).
  - [services.openntpd @ NixOS reference](https://search.nixos.org/options?query=services.openntpd.).
  - [services.chrony NixOS reference](https://search.nixos.org/options?query=services.chrony.).

  ## 🙇 Acknowledgements

  - [NTP @ Official NixOS Wiki](https://wiki.nixos.org/wiki/NTP).
  - [Chrony @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Chrony).
  - [NTP @ NixOS Wiki](https://nixos.wiki/wiki/NTP).
  - [systemd-timesyncd @ ArchLinux Wiki](https://wiki.archlinux.org/title/Systemd-timesyncd).
  - [Les USA peuvent paralyser téléphone, banque et hôpital en une seconde ? @ Choses à Savoir TECH's acast :fr:](https://shows.acast.com/choses-a-savoir-technologie/episodes/les-usa-peuvent-paralyser-telephone-banque-et-hopital-en-une).
  - [Diffusion de l’heure par internet - NTP : Network Time Protocol @ Observatoire de Paris :fr:](https://syrte.obspm.fr/spip/fr/services/ref-temps/article/diffusion-de-l-heure-par-internet-ntp-network-time-protocol.html).
*/
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;

  cfg = config.biapy.networking.ntp;
in
{
  options = {
    biapy.networking.ntp = {
      enable = mkEnableOption "ntp servers";

      service = mkOption {
        type = enum [
          "timesyncd"
          "ntp"
          "ntpd-rs"
          "openntpd"
          "chrony"
        ];
        default = "timesyncd";
        description = ''
          NTP daemon to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.timeServers =
      mkDefault [
        "ntp-p1.obspm.fr"
        "145.238.80.80"
        "ntp.obspm.fr"
        "145.238.80.83"
        "0.europe.pool.ntp.org"
        "1.europe.pool.ntp.org"
        "2.europe.pool.ntp.org"
        "3.europe.pool.ntp.org"
      ]
      ++ options.networking.timeServers.default;

    services = {
      timesyncd.enable = mkDefault (cfg.service == "timesyncd") && !config.boot.isContainer;
      ntp.enable = mkDefault (cfg.service == "ntp") && !config.boot.isContainer;
      ntpd-rs.enable = mkDefault (cfg.service == "ntpd-rs") && !config.boot.isContainer;
      openntpd.enable = mkDefault (cfg.service == "openntpd") && !config.boot.isContainer;
      chrony.enable = mkDefault (cfg.service == "chrony") && !config.boot.isContainer;
    };
  };

}
