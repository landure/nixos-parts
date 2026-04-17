/**
  # nix-unit

  ## 🛠️ Tech Stack

  - [nix-unit homepage](https://nix-community.github.io/nix-unit/)
    ([nix-unit @ GitHub](https://github.com/nix-community/nix-unit)).
  - [flake-parts homepage](https://flake.parts/)
    ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).

  ## 🙇 Acknowledgements

  - [Dendrix](https://dendrix.oeiuwq.com/index.html).
*/
{ inputs, lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  flake-file.inputs = {
    devshell.url = mkDefault "github:numtide/devshell";
    nix-unit = {
      url = mkDefault "github:nix-community/nix-unit";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        flake-parts.follows = mkDefault "flake-parts";
      };
    };
  };

  imports = [
    (inputs.devshell.flakeModule or { })
    (inputs.nix-unit.modules.flake.default or { })
  ];

  perSystem =
    { lib, pkgs, ... }:
    {
      nix-unit = {
        # NOTE: a `nixpkgs-lib` follows rule is currently required
        inherit inputs;
      };

      devshells.default = {
        packages = with pkgs; [ nix-unit ];

        commands = [
          {
            name = "nix-unit-tests";
            help = "run nix-unit tests";
            command = "${lib.getExe pkgs.nix-unit} --flake '.#checks'";
            category = "tests";
          }
        ];
      };
    };
}
