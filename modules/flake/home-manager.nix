/**
  # home-manager integration

  ## 🛠️ Tech Stack

  - [Home Manager homepage](https://home-manager.dev/)
    ([Home Manager @ GitHub](https://github.com/nix-community/home-manager)).
  - [flake-parts homepage](https://flake.parts/)
    ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).

  ## 📝 Documentation

  - [home-manager @ flake-parts](https://flake.parts/options/home-manager.html).
*/
{
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    (inputs.flake-parts.flakeModules.modules or { })
    (inputs.home-manager.flakeModules.home-manager or { })
  ];

  flake-file.inputs.home-manager = {
    url = mkDefault "github:nix-community/home-manager";
    inputs = {
      nixpkgs.follows = mkDefault "nixpkgs";
    };
  };

}
