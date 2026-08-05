/**
  # nix-index-database integration

  ## 🛠️ Tech Stack

  - [nix-index-database @ GitHub](https://github.com/nix-community/nix-index-database).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).
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
    (inputs.nix-index-database.homeModules.default or { })
  ];

  flake-file.inputs.nix-index-database = {
    url = mkDefault "github:nix-community/nix-index-database";
    inputs = {
      nixpkgs.follows = mkDefault "nixpkgs";
    };
  };
}
