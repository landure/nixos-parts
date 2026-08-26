/**
  # Flatpak

  Flatpak is a Linux application sandboxing and distribution framework.

  ## 🛠️ Tech Stack

  - [Flatpak homepage](https://flatpak.org/).
  - [Warehouse @ GitHub](https://github.com/flattool/warehouse).

  ## 📝 Documentation

  - [services.flatpak @ NixOS reference](https://search.nixos.org/options?query=services.flatpak).

  ## 🙇 Acknowledgements

  - [Flatpak @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Flatpak).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.services.flatpak;
in
{
  options.biapy.services.flatpak.enable = mkEnableOption "XDG Base Directory";

  config = mkIf cfg.enable {
    # Flatpak requires XDG portal to integrate properly with desktop.
    biapy.xdg.portal.enable = mkDefault true;

    services.flatpak.enable = mkDefault true;

    environment.defaultPackages = with pkgs; [ warehouse ];
  };
}
