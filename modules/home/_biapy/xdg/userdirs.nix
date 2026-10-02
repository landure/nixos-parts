/**
  # XDG User Directories

  XDG user directories are well-known user folders like Desktop, Documents,
  Downloads, Music, Pictures, and Videos. The `xdg-user-dirs` package
  generates `$XDG_CONFIG_HOME/user-dirs.dirs` which defines these locations.

  ## 🛠️ Tech Stack

  - [XDG Base Directory Specification @ freedesktop.org](https://specifications.freedesktop.org/basedir-spec/latest/).
  - [xdg-user-dirs @ GitLab](https://gitlab.freedesktop.org/xdg/xdg-user-dirs).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [xdg.userDirs @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.userDirs.enable).
  - [xdg.userDirs.extraConfig @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.userDirs.extraConfig).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) enum;

  cfg = config.biapy.xdg.userDirs;

  defaults = {
    french = {
      desktop = "Bureau";
      documents = "Documents";
      download = "Téléchargements";
      music = "Musique";
      pictures = "Images";
      publicShare = "Public";
      templates = "Modèles";
      videos = "Vidéos";
    };

    english = {
      desktop = "Desktop";
      documents = "Documents";
      download = "Downloads";
      music = "Music";
      pictures = "Pictures";
      publicShare = "Public";
      templates = "Templates";
      videos = "Videos";
    };
  };
in
{
  options.biapy.xdg.userDirs = {
    enable = mkEnableOption "XDG user directories";

    language = mkOption {
      type = enum [
        "french"
        "english"
      ];
      description = "Language for XDG user directory names.";
    };
  };

  config = mkIf cfg.enable {
    xdg.userDirs = mkDefault (
      {
        enable = true;
      }
      // defaults.${cfg.language}
    );
  };
}
