/**
  # GNOME Keyring

  GNOME Keyring is "a collection of components in GNOME that store secrets,
  passwords, keys, certificates and make them available to applications."

  ## 🛠️ Tech Stack

  - [GNOME Keyring @ GNOME's GitLab](https://gitlab.gnome.org/GNOME/gnome-keyring).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [services.gnome-keyring @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.gnome-keyring.enable).
  - [services.gnome-keyring @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.gnome-keyring.).

  ## 🙇 Acknowledgements

  - [GNOME Keyring @ Arch Linux Wiki](https://wiki.archlinux.org/title/GNOME/Keyring).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.services.gnome-keyring;
in
{
  options.biapy.services.gnome-keyring.enable = mkEnableOption "GNOME Keyring service";

  config = mkIf cfg.enable {
    services.gnome-keyring = {
      enable = mkDefault true;
      # components = [ "pkcs11" "secrets" "ssh" ];
    };

    # xdg.portal.config.common as an exception.
    xdg.portal.config = {
      common."org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      gnome."org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };
}
