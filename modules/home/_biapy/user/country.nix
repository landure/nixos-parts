/**
  # User Country

  Country information for the user: primary language, ISO 3166-1 codes, and recommended locale.

  The setting accepts an ISO 3166-1 alpha-2 code, alpha-3 code, or country name,
  and returns the country attribute set via `apply`.

  ## 📝 Documentation

  ### 🌍 ISO 3166-1

  - [ISO 3166-1 @ Wikipedia](https://en.wikipedia.org/wiki/ISO_3166-1).
*/
{
  lib,
  ...
}:
let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) concatMap findFirst;
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr;

  countries = {
    "FR" = {
      name = "France";
      codes = {
        alpha2 = "FR";
        alpha3 = "FRA";
      };
      language = "french";
      locale = "fr_FR.UTF-8";
    };
    "US" = {
      name = "United States";
      codes = {
        alpha2 = "US";
        alpha3 = "USA";
      };
      language = "english";
      locale = "en_US.UTF-8";
    };
    "GB" = {
      name = "United Kingdom";
      codes = {
        alpha2 = "GB";
        alpha3 = "GBR";
      };
      language = "english";
      locale = "en_GB.UTF-8";
    };
  };

  countryList = attrValues countries;

  allCodes = concatMap (c: [
    c.codes.alpha2
    c.codes.alpha3
    c.name
  ]) countryList;

  lookup =
    code:
    if countries ? ${code} then
      countries.${code}
    else
      let
        byAlpha3 = findFirst (c: c.codes.alpha3 == code) null countryList;
      in
      if byAlpha3 != null then byAlpha3 else findFirst (c: c.name == code) null countryList;
in
{
  options.biapy.user.country = mkOption {
    type = nullOr (enum allCodes);
    default = null;
    apply = code: if code == null then null else lookup code;
    description = ''
      User country. Accepts an ISO 3166-1 alpha-2 code (e.g. `FR`), alpha-3 code
      (e.g. `FRA`), or country name (e.g. `France`), and returns the country
      attribute set containing `name`, `codes`, `language`, and `locale`.
      Defaults to `null`, meaning the country is unset and must be configured
      by the user before use.
    '';
  };
}
