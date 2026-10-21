{ lib, ... }:
let
  inherit (lib.modules) evalModules;

  countryModule = ../../../../home/_biapy/user/country.nix;
  languageModule = ../../../../home/_biapy/user/language.nix;

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

  stub = {
    home.language = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
      default = null;
    };
    home.sessionVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
    targets.genericLinux.enable = lib.mkEnableOption "generic Linux";
  };

  evalLanguage =
    modules:
    (evalModules {
      modules = [
        stub
        countryModule
        languageModule
      ] ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.user.language" = {
    "test: disabled by default" = {
      expr = evalLanguage [ ].biapy.user.language.enable;
      expected = false;
    };

    "test: language defaults to english when country is unset" = {
      expr = evalLanguage [ ].biapy.user.language.language;
      expected = "english";
    };

    "test: language follows country language" = {
      expr = evalLanguage [ { biapy.user.country = "FR"; } ].biapy.user.language.language;
      expected = "french";
    };

    "test: explicit language overrides country" = {
      expr =
        evalLanguage
          [
            {
              biapy.user.country = "FR";
              biapy.user.language.language = "english";
            }
          ]
          .biapy.user.language.language;
      expected = "english";
    };

    "test: home.language is unset when disabled" = {
      expr = evalLanguage [ ].home.language;
      expected = null;
    };

    "test: french locale is applied when enabled" = {
      expr =
        evalLanguage
          [
            {
              biapy.user.language = {
                enable = true;
                language = "french";
              };
            }
          ]
          .home.language;
      expected = frenchLocale;
    };

    "test: english locale is applied when enabled" = {
      expr =
        evalLanguage
          [
            {
              biapy.user.language = {
                enable = true;
                language = "english";
              };
            }
          ]
          .home.language;
      expected = englishLocale;
    };

    "test: locale follows country when enabled" = {
      expr =
        evalLanguage
          [
            {
              biapy.user.country = "FR";
              biapy.user.language.enable = true;
            }
          ]
          .home.language;
      expected = frenchLocale;
    };

    "test: LOCALE_ARCHIVE session variable is set on generic Linux" = {
      expr =
        evalLanguage
          [
            {
              biapy.user.language.enable = true;
              targets.genericLinux.enable = true;
            }
          ]
          .home.sessionVariables.LOCALE_ARCHIVE;
      expected = "/usr/lib/locale/locale-archive";
    };

    "test: LOCALE_ARCHIVE session variable is unset without generic Linux" = {
      expr =
        evalLanguage
          [
            {
              biapy.user.language.enable = true;
              targets.genericLinux.enable = false;
            }
          ]
          .home.sessionVariables.LOCALE_ARCHIVE or null;
      expected = null;
    };
  };
}
