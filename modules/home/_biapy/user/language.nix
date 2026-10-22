/**
  # User Language

  Configure locale and language settings for the user session.

  The setting accepts a language name (e.g. `french`) and returns a language
  attribute set via `apply`, containing the display `name`, the `locales` to
  use for the session, the ISO 639-1 code, the `locale` and its `charset`.

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
  inherit (lib.attrsets) attrNames;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr;

  cfg = config.biapy.user;

  languages = {
    "french" = {
      name = "French";
      iso-639-1 = "fr";
      locale = "fr_FR";
      charset = "UTF-8";
      locales = {
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
    };

    "english" = {
      name = "English";
      iso-639-1 = "en";
      locale = "en_US";
      charset = "UTF-8";
      locales = {
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
    };
  };
in
{
  options.biapy.user.language = mkOption {
    type = nullOr (enum (attrNames languages));
    default = config.biapy.user.country.language or null;
    apply = language: if language == null then null else languages.${language};
    description = ''
      User language. Accepts a language name (e.g. `french`) and returns the
      language attribute set containing `name`, `locales`, `iso-639-1`, `locale`
      and `charset`.
      Defaults to the language of the configured `biapy.user.country`, or `null`
      when the country is unset.
    '';
  };

  config = mkIf (cfg.language != null) {
    home.language = cfg.language.locales;

    home.sessionVariables = mkIf config.targets.genericLinux.enable {
      LOCALE_ARCHIVE = mkDefault "/usr/lib/locale/locale-archive";
    };
  };
}
