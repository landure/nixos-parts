/**
  # biapy-parts' packages & overlay

  ## 🛠️ Tech Stack

  - [pkgs-by-name for flake.parts @ GitHub](https://github.com/drupol/pkgs-by-name-for-flake-parts).

  ## 📝 Documentation

  - [pkgs-by-name-for-flake-parts @ flake-parts](https://flake.parts/options/pkgs-by-name-for-flake-parts.html).
*/
{
  inputs,
  lib,
  self,
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
      (
        localFlake: final: prev:
        withSystem prev.stdenv.hostPlatform.system (
          { config, system, ... }:
          {
            unstable = import localFlake.inputs.nixpkgs-unstable {
              inherit system;
              nixpkgs.config = config.nixpkgs.config;
            };
            biapy-parts = localFlake.packages.${system};
            spicetify-nix = localFlake.inputs.spicetify-nix.legacyPackages.${system};
          }
        )
      )
        {
          inputs = { inherit (inputs) nixpkgs-unstable spicetify-nix; };
          inherit (self) packages;
        };
  };
}
