/**
  # home-manager integration

  ## 🛠️ Tech Stack

  - [pkgs-by-name for flake.parts @ GitHub](https://github.com/drupol/pkgs-by-name-for-flake-parts).

  ## 📝 Documentation

  - [pkgs-by-name-for-flake-parts @ flake-parts](https://flake.parts/options/pkgs-by-name-for-flake-parts.html).
*/
{
  inputs,
  lib,
  withSystem,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    (inputs.pkgs-by-name-for-flake-parts.flakeModule or { })
  ];

  flake-file.inputs.pkgs-by-name-for-flake-parts = {
    url = mkDefault "github:drupol/pkgs-by-name-for-flake-parts";
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.self.overlays.default
        ];
      };
      pkgsDirectory = ../../packages;
    };

  flake = {
    overlays.default =
      final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { config, ... }:
        {
          local = config.packages;
        }
      );
  };

}
