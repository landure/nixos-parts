/**
  # Macchina

  Macchina is a system information frontend with an emphasis on performance.

  ## 🛠️ Tech Stack

  - [macchina @ GitHub](https://github.com/Macchina-CLI/macchina)

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [home.file.<name> @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=home.file.%3Cname%3E).
  - [programs.macchina @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.macchina.enable).
  - [programs.macchina @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.macchina.).
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
  inherit (pkgs) fetchurl;

  cfg = config.biapy.programs.macchina;

  themesHome = "${config.xdg.configHome}/macchina/themes";
in
{
  options = {
    biapy.programs.macchina.enable = mkEnableOption "macchina";
  };

  config = mkIf cfg.enable {
    programs.macchina = {
      enable = mkDefault true;
    };

    home.file = {
      "${themesHome}/Beryllium.toml".source = mkDefault (fetchurl {
        url = "https://raw.githubusercontent.com/Macchina-CLI/macchina/c049088c20ed90d0993c9fae0c6e09f22dbea0dd/contrib/themes/Beryllium.toml";
        hash = "sha256-EDiSwNYXTtG8bbWHs6p6SU+aV4nbPQeNAYa8NenvZuo=";
      });
      "${themesHome}/Helium.toml".source = mkDefault (fetchurl {
        url = "https://raw.githubusercontent.com/Macchina-CLI/macchina/c049088c20ed90d0993c9fae0c6e09f22dbea0dd/contrib/themes/Helium.toml";
        hash = "sha256-UjHHVjiDNerYiRtK9MzsC5DGev+51mSmH+DQGwYDSWM=";
      });
      "${themesHome}/Hydrogen.toml".source = mkDefault (fetchurl {
        url = "https://raw.githubusercontent.com/Macchina-CLI/macchina/c049088c20ed90d0993c9fae0c6e09f22dbea0dd/contrib/themes/Hydrogen.toml";
        hash = "sha256-QOb5/e+qJ2iTh7PoemsawkhDjrzKnvZlsdraVBtUDpQ=";
      });
      "${themesHome}/Lithium.toml".source = mkDefault (fetchurl {
        url = "https://raw.githubusercontent.com/Macchina-CLI/macchina/c049088c20ed90d0993c9fae0c6e09f22dbea0dd/contrib/themes/Lithium.toml";
        hash = "sha256-PGJjemRBN7IQPHd3mynQ6KjmhT4nKbRlOaaxdKaplZw=";
      });
    };
  };
}
