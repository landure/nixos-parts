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
  withSystem,
  ...
}:
let
  inherit (lib.modules) mkDefault;

  localFlake = {
    inherit inputs;
    self = { inherit (self) homeModules overlays; };
  };

  biapyHomeModule = localFlake: _: {
    # nixpkgs.overlays = [
    #   localFlake.self.overlays.default
    # ];
    imports = [
      localFlake.inputs.sops-nix.homeManagerModules.sops
      localFlake.inputs.nix-index-database.homeModules.default
      localFlake.inputs.lan-mouse.homeManagerModules.default
      localFlake.inputs.stylix.homeModules.stylix
      localFlake.inputs.spicetify-nix.homeManagerModules.spicetify
      localFlake.inputs.sofka.homeManagerModules.default
      (localFlake.inputs.import-tree ./_biapy)
    ];
  };
in
{
  flake-file.inputs = {
    dbdelve = {
      url = mkDefault "github:ShayanAbbas1/dbdelve/v0.8.0";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
    };
    flyline = {
      url = mkDefault "github:HalFrgrd/flyline";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
    };
    helix-notes = {
      url = mkDefault "gitlab:ArkHost/HelixNotes";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        flake-utils.follows = mkDefault "flake-utils";
      };
    };
    lan-mouse = {
      url = mkDefault "github:feschber/lan-mouse/v0.11.0";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
      };
    };
    llm-agents = {
      url = mkDefault "github:numtide/llm-agents.nix";
    };
    quien = {
      url = mkDefault "github:retlehs/quien";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        flake-utils.follows = mkDefault "flake-utils";
      };
    };
    sofka = {
      url = mkDefault "github:nklmilojevic/sofka";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        home-manager.follows = mkDefault "home-manager";
      };
    };
  };

  flake = {
    overlays.biapy-parts-home =
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
            dbdelve = localFlake.inputs.dbdelve.packages.${system};
            flyline = localFlake.inputs.flyline.packages.${system};
            helix-notes = localFlake.inputs.helix-notes.packages.${system};
            lan-mouse = localFlake.inputs.lan-mouse.packages.${system};
            llm-agents = localFlake.inputs.llm-agents.packages.${system};
            quien = localFlake.inputs.quien.packages.${system};
            sofka = localFlake.inputs.sofka.packages.${system};
            spicetify-nix = localFlake.inputs.spicetify-nix.legacyPackages.${system};
          }
        )
      )
        {
          inputs = {
            inherit (inputs)
              nixpkgs-unstable
              dbdelve
              flyline
              helix-notes
              lan-mouse
              llm-agents
              quien
              sofka
              spicetify-nix
              ;
          };
          inherit (self) packages;
        };

    modules.homeManager = {
      default = config.flake.modules.homeManager.biapy;
      biapy = biapyHomeModule localFlake;
    };

    homeModules = config.flake.modules.homeManager;

    nixConfig = {
      # llm-agents binary cache
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
    };

    tests = {
      modules.home = {
        "test: declares modules.homeManager.biapy" = {
          expr = config.flake.modules.homeManager ? biapy;
          expected = true;
        };

        "test: declares modules.homeManager.default" = {
          expr = config.flake.modules.homeManager ? default;
          expected = true;
        };
      };

      homeModules.biapy = {
        "test: declares flake.homeModules.biapy" = {
          expr = config.flake.homeModules ? biapy;
          expected = true;
        };
      };
    };
  };
}
