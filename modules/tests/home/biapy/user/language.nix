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

  frenchLanguage = {
    name = "French";
    iso-639-1 = "fr";
    locale = "fr_FR";
    charset = "UTF-8";
    locales = frenchLocale;
  };

  englishLanguage = {
    name = "English";
    iso-639-1 = "en";
    locale = "en_US";
    charset = "UTF-8";
    locales = englishLocale;
  };

  stub = {
    options = {
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
  };

  evalLanguage =
    modules:
    (evalModules {
      modules = [
        stub
        countryModule
        languageModule
      ]
      ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.user.language" = {
    "test: language defaults to null when country is unset" = {
      expr = (evalLanguage [ ]).biapy.user.language;
      expected = null;
    };

    "test: language follows country language" = {
      expr = (evalLanguage [ { biapy.user.country = "FR"; } ]).biapy.user.language;
      expected = frenchLanguage;
    };

    "test: explicit language overrides country" = {
      expr =
        (evalLanguage [
          {
            biapy.user.country = "FR";
            biapy.user.language = "english";
          }
        ]).biapy.user.language;
      expected = englishLanguage;
    };

    "test: language exposes its name" = {
      expr = (evalLanguage [ { biapy.user.language = "french"; } ]).biapy.user.language.name;
      expected = "French";
    };

    "test: language exposes its ISO 639-1 code" = {
      expr = (evalLanguage [ { biapy.user.language = "french"; } ]).biapy.user.language."iso-639-1";
      expected = "fr";
    };

    "test: language exposes its locale" = {
      expr = (evalLanguage [ { biapy.user.language = "french"; } ]).biapy.user.language.locale;
      expected = "fr_FR";
    };

    "test: language exposes its charset" = {
      expr = (evalLanguage [ { biapy.user.language = "french"; } ]).biapy.user.language.charset;
      expected = "UTF-8";
    };

    "test: language exposes its locales" = {
      expr = (evalLanguage [ { biapy.user.language = "french"; } ]).biapy.user.language.locales;
      expected = frenchLocale;
    };

    "test: home.language is unset when language is null" = {
      expr = (evalLanguage [ ]).home.language;
      expected = null;
    };

    "test: french locale is applied" = {
      expr = (evalLanguage [ { biapy.user.language = "french"; } ]).home.language;
      expected = frenchLocale;
    };

    "test: english locale is applied" = {
      expr = (evalLanguage [ { biapy.user.language = "english"; } ]).home.language;
      expected = englishLocale;
    };

    "test: locale follows country" = {
      expr = (evalLanguage [ { biapy.user.country = "FR"; } ]).home.language;
      expected = frenchLocale;
    };

    "test: LOCALE_ARCHIVE session variable is set on generic Linux" = {
      expr =
        (evalLanguage [
          {
            biapy.user.language = "french";
            targets.genericLinux.enable = true;
          }
        ]).home.sessionVariables.LOCALE_ARCHIVE;
      expected = "/usr/lib/locale/locale-archive";
    };

    "test: LOCALE_ARCHIVE session variable is unset without generic Linux" = {
      expr =
        (evalLanguage [
          {
            biapy.user.language = "french";
            targets.genericLinux.enable = false;
          }
        ]).home.sessionVariables.LOCALE_ARCHIVE or null;
      expected = null;
    };
  };
}
