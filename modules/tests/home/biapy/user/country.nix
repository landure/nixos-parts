{ lib, ... }:
let
  inherit (lib.modules) evalModules;

  countryModule = ../../../../home/_biapy/user/country.nix;

  evalCountry = modules: lib.debug.traceVal (
    evalModules {
      modules = [ countryModule ] ++ modules;
    }).config.biapy.user.country;
in
{
  flake.tests."home.biapy.user.country" = {
    "test: default value is null" = {
      expr = evalCountry [ ];
      expected = null;
    };

    "test: explicit null is null" = {
      expr = evalCountry [{ biapy.user.country = null; }];
      expected = null;
    };

    "test: alpha2 takes precedence over alpha3" = {
      expr = evalCountry [{ biapy.user.country = "FR"; }];
      expected = evalCountry [{ biapy.user.country = "FRA"; }];
    };

    "test: alpha2 code FR resolves to France" = {
      expr = evalCountry [{ biapy.user.country = "FR"; }];
      expected = {
        name = "France";
        codes = { alpha2 = "FR"; alpha3 = "FRA"; };
        language = "french";
        locale = "fr_FR.UTF-8";
      };
    };

    "test: alpha3 code FRA resolves to France" = {
      expr = evalCountry [{ biapy.user.country = "FRA"; }];
      expected = {
        name = "France";
        codes = { alpha2 = "FR"; alpha3 = "FRA"; };
        language = "french";
        locale = "fr_FR.UTF-8";
      };
    };

    "test: country name France resolves correctly" = {
      expr = evalCountry [{ biapy.user.country = "France"; }];
      expected = {
        name = "France";
        codes = { alpha2 = "FR"; alpha3 = "FRA"; };
        language = "french";
        locale = "fr_FR.UTF-8";
      };
    };

    "test: alpha2 code US resolves to United States" = {
      expr = evalCountry [{ biapy.user.country = "US"; }];
      expected = {
        name = "United States";
        codes = { alpha2 = "US"; alpha3 = "USA"; };
        language = "english";
        locale = "en_US.UTF-8";
      };
    };

    "test: alpha3 code USA resolves to United States" = {
      expr = evalCountry [{ biapy.user.country = "USA"; }];
      expected = {
        name = "United States";
        codes = { alpha2 = "US"; alpha3 = "USA"; };
        language = "english";
        locale = "en_US.UTF-8";
      };
    };

    "test: country name United States resolves correctly" = {
      expr = evalCountry [{ biapy.user.country = "United States"; }];
      expected = {
        name = "United States";
        codes = { alpha2 = "US"; alpha3 = "USA"; };
        language = "english";
        locale = "en_US.UTF-8";
      };
    };

    "test: alpha2 code GB resolves to United Kingdom" = {
      expr = evalCountry [{ biapy.user.country = "GB"; }];
      expected = {
        name = "United Kingdom";
        codes = { alpha2 = "GB"; alpha3 = "GBR"; };
        language = "english";
        locale = "en_GB.UTF-8";
      };
    };

    "test: alpha3 code GBR resolves to United Kingdom" = {
      expr = evalCountry [{ biapy.user.country = "GBR"; }];
      expected = {
        name = "United Kingdom";
        codes = { alpha2 = "GB"; alpha3 = "GBR"; };
        language = "english";
        locale = "en_GB.UTF-8";
      };
    };

    "test: country name United Kingdom resolves correctly" = {
      expr = evalCountry [{ biapy.user.country = "United Kingdom"; }];
      expected = {
        name = "United Kingdom";
        codes = { alpha2 = "GB"; alpha3 = "GBR"; };
        language = "english";
        locale = "en_GB.UTF-8";
      };
    };

  };
}
