/**
  # User Language

  Configure locale and language settings for the user session.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [home.language @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-home.language.base).
  - [home.language @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=home.language.).

  ## 🙇 Acknowledgements

  - [Flameshot @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Locales).
  - [Locale @ Arch Linux Wiki](https://wiki.archlinux.org/title/Locale).
  - [locale(5) — Linux manual page](https://www.man7.org/linux/man-pages/man5/locale.5.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;

  cfg = config.biapy.user.language;

  frenchLocale = {
    base = "fr_FR.UTF-8";
    address = "fr_FR.UTF-8";
    collate = "fr_FR.UTF-8";
    ctype = "fr_FR.UTF-8";
    measurement = "fr_FR.UTF-8";
    messages = "fr_FR.UTF-8";
    monetary = "fr_FR.UTF-8";
    name = "fr_FR.UTF-8";
    numeric = "fr_FR.UTF-8";
    paper = "fr_FR.UTF-8";
    telephone = "fr_FR.UTF-8";
    time = "fr_FR.UTF-8";
  };

  englishLocale = {
    base = "en_US.UTF-8";
    address = "en_US.UTF-8";
    collate = "en_US.UTF-8";
    ctype = "en_US.UTF-8";
    measurement = "en_US.UTF-8";
    messages = "en_US.UTF-8";
    monetary = "en_US.UTF-8";
    name = "en_US.UTF-8";
    numeric = "en_US.UTF-8";
    paper = "en_US.UTF-8";
    telephone = "en_US.UTF-8";
    time = "en_US.UTF-8";
  };
in
{
  options.biapy.user.language = {
    enable = mkEnableOption "User language settings";

    language = mkOption {
      type = enum [
        "french"
        "english"
      ];
      default = "english";
      description = "Language for locale settings.";
    };
  };

  config = mkIf cfg.enable {
    home.language = if cfg.language == "french" then frenchLocale else englishLocale;

    home.sessionVariables = mkIf config.targets.genericLinux.enable {
      LOCALE_ARCHIVE = mkDefault "/usr/lib/locale/locale-archive";
    };
  };
}
