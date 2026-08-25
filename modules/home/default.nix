/**
  # flake-file base inputs

  ## 🛠️ Tech Stack

  - [Home Manager homepage](https://home-manager.dev/)
    ([Home Manager @ GitHub](https://github.com/nix-community/home-manager)).
  - [Stylix homepage](https://nix-community.github.io/stylix)
    ([Stylix @ GitHub](https://github.com/nix-community/stylix)).
  - [flake-parts homepage](https://flake.parts/)
    ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).

  ## 📝 Documentation

  - [flake-parts.flakeModules @ flake-parts](https://flake.parts/options/flake-parts-flakemodules).

  ## 🙇 Acknowledgements

  - [Dendrix](https://dendrix.oeiuwq.com/index.html).
*/
{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib.modules) mkDefault;
in
{
  flake-file.inputs = {
    nixpkgs-lib.follows = mkDefault "nixpkgs";
    home-manager = {
      url = mkDefault "github:nix-community/home-manager";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flyline = {
      url = mkDefault "github:HalFrgrd/flyline";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
      };
    };
    quien = {
      url = mkDefault "github:retlehs/quien";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    spicetify = {
      url = mkDefault "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
      };
    };
    stylix = {
      url = mkDefault "github:nix-community/stylix/release-26.05";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        flake-parts.follows = mkDefault "flake-parts";
      };
    };
  };

  flake = {

    modules.homeManager =
      let
        localFlake = {
          inputs = {
            inherit (inputs)
              import-tree
              nix-index-database
              spicetify-nix
              stylix
              ;
          };
          self = { inherit (self) homeModules overlays; };
        };

        biapyHomeModule = localFlake: _: {
          # nixpkgs.overlays = [
          #   localFlake.self.overlays.default
          # ];
          imports = [
            localFlake.inputs.nix-index-database.homeModules.default
            localFlake.inputs.stylix.homeModules.stylix
            localFlake.inputs.spicetify-nix.homeManagerModules.spicetify
            (localFlake.inputs.import-tree ./_biapy)
          ];
        };
      in
      {
        default = config.flake.modules.homeManager.biapy;
        biapy = biapyHomeModule localFlake;
      };

    homeModules = {
      biapy = config.flake.modules.homeManager.biapy;
      default = config.flake.homeModules.biapy;
    };

    tests = {
      "modules.home" = {
        "test: declares modules.home.biapy" = {
          expr = config.flake.modules.home ? biapy;
          expected = true;
        };

        "test: declares modules.home.default" = {
          expr = config.flake.modules.home ? default;
          expected = true;
        };
      };

      "homeModules.biapy" = {
        "test: declares flake.homeModules.biapy" = {
          expr = config.flake.homeModules ? biapy;
          expected = true;
        };
      };
    };
  };
}
