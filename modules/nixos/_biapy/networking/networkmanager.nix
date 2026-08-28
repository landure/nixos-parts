/**
  # NetworkManager

  ## 🛠️ Tech Stack

  - [NetworkManager](https://www.networkmanager.dev/).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [networking @ NixOS reference](https://search.nixos.org/options?query=networking.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.attrsets) attrNames;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.networking.networkmanager;
in
{
  options.biapy.networking.networkmanager.enable = mkEnableOption "NetworkManager";

  config = mkIf cfg.enable {
    users.groups.networkmanager.members = attrNames config.home-manager.users;

    networking.networkmanager = {
      enable = mkDefault true;
      dhcp = if config.networking.dhcpcd.enable then "dhcpcd" else "internal";
    };
  };
}
