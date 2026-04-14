/**
  # flake-file base inputs

  ## 🛠️ Tech Stack

  - [flake-parts homepage](https://flake.parts/)
    ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).

  ## 📝 Documentation

  - [flake-parts.flakeModules @ flake-parts](https://flake.parts/options/flake-parts-flakemodules).

  ## 🙇 Acknowledgements

  - [Dendrix](https://dendrix.oeiuwq.com/index.html).
*/
{ inputs, lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  flake-file = {
    description = "Dendritic NixOS and Home Manager modules for flake-file and flake-parts.";

    formatter = pkgs: pkgs.nixfmt;
    prune-lock.enable = mkDefault true;

    inputs = {
      flake-file.url = mkDefault "github:vic/flake-file";
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixpkgs-lib.follows = "nixpkgs";

    };
  };

  imports =

    [
      # makes deduplication and disabledModules work
      # flake-parts.flakeModules.flakeModules
      # enable inside-flake and say goodbye to bootstrap
      (inputs.flake-file.flakeModules.dendritic or { })
      (inputs.flake-file.flakeModules.nix-auto-follow or { })
    ];

  systems = [
    "x86_64-linux"
    # "aarch64-linux"
    # "aarch64-darwin"
    # "x86_64-darwin"
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
