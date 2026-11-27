/**
  # Database

  ## 🛠 Tech Stack

  - [DBdelve homepage](https://dbdelve.github.io/)
    ([DBdelve @ GitHub](https://github.com/ShayanAbbas1/dbdelve))
  - [DBeaver homepage](https://dbeaver.io/)
    ([DBeaver @ GitHub](https://github.com/dbeaver/dbeaver)).
  - [Harlequin homepage](https://harlequin.sh/)
    ([Harlequin @ GitHub](https://github.com/tconbeer/harlequin)).
  - [MongoDB Compass](https://mongodb.com/compass)
    ([MongoDB Compass @ GitHub](https://github.com/mongodb-js/compass)).
  - [usql @ GitHub](https://github.com/xo/usql).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.lazysql @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/lazysql.html).
  - [programs.lazysql @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.lazysql.).
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

  cfg = config.biapy.dev.database;

in
{
  options.biapy.dev.database.enable = mkEnableOption "database development tools";

  config = mkIf cfg.enable {
    programs.lazysql.enable = mkDefault true;

    home.packages = with pkgs; [
      dbeaver-bin
      usql
      # harlequin
      # mongodb-compass

      dbdelve.dbdelve
    ];
  };
}
