/**
  # Networking support

  ## 📝 Documentation

  ### ❄️ NixOS

  - [systemd.network @ NixOS reference](https://search.nixos.org/options?query=systemd.network.).

  ## 🙇 Acknowledgements

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
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.networking.systemd-networkd;
in
{
  options.biapy.networking.systemd-networkd.enable = mkEnableOption "systemd networkd";

  config = mkIf cfg.enable {
    systemd.network.enable = mkDefault true;
    networking.dhcpcd.enable = mkDefault false;
  };
}
