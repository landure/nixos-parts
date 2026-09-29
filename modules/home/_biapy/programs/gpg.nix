/**
  # GnuPG

  ## 🛠️ Tech Stack

  - [GnuPG homepage](https://gnupg.org/)
    is a complete and free implementation of the OpenPGP standard
    as defined by RFC4880 (also known as PGP).
  - [gpg-tui @ GitHub](https://github.com/orhun/gpg-tui)
    is a terminal user interface for GnuPG.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.gpg @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.enable).
  - [programs.gpg @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.gpg.).
  - [programs.gpg-agent @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg-agent.enable).
  - [programs.gpg-agent @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.gpg-agent.).
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

  cfg = config.biapy.programs.gpg;
in
{
  options.biapy.programs.gpg.enable = mkEnableOption "GnuPG";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gpg-tui
    ];

    programs = {
      gpg.enable = mkDefault true;
      # gpg-agent.enable = mkDefault true;
    };
  };
}
