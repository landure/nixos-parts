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

  localFlake = {
    inputs = {
      inherit (inputs)
        import-tree
        sops-nix
        nix-index-database
        sofka
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
      localFlake.inputs.sops-nix.homeManagerModules.sops
      localFlake.inputs.nix-index-database.homeModules.default
      localFlake.inputs.stylix.homeModules.stylix
      localFlake.inputs.spicetify-nix.homeManagerModules.spicetify
      localFlake.inputs.sofka.homeManagerModules.default
      (localFlake.inputs.import-tree ./_biapy)
    ];
  };
in
{
  flake-file.inputs = {
    nixpkgs-lib.follows = mkDefault "nixpkgs";
    home-manager = {
      url = mkDefault "github:nix-community/home-manager";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
    };
    sops-nix = {
      url = mkDefault "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
    };
    flake-utils.url = mkDefault "github:numtide/flake-utils";
    flyline = {
      url = mkDefault "github:HalFrgrd/flyline";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
    };
    helix-notes = {
      url = mkDefault "git+https://gitlab.com/ArkHost/HelixNotes";
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
    quien = {
      url = mkDefault "github:retlehs/quien";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
        flake-utils.follows = mkDefault "flake-utils";
      };
    };
    spicetify-nix = {
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
    modules.homeManager = {
      default = config.flake.modules.homeManager.biapy;
      biapy = biapyHomeModule localFlake;
    };

    homeModules = config.flake.modules.homeManager;

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
