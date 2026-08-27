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
        home-manager
        nix-index-database
        sops-nix
        spicetify-nix
        stylix
        ;
    };
    self = { inherit (self) nixosModules overlays; };
  };

  biapyUsersNixOSModule = localFlake: _: {
    imports = [
      localFlake.inputs.sops-nix.nixosModules.sops
      (localFlake.inputs.import-tree ./_biapy_users)
    ];
  };

  biapyNixOSModule = localFlake: _: {
    # nixpkgs.overlays = [
    #   localFlake.self.overlays.default
    # ];
    imports = [
      localFlake.inputs.home-manager.nixosModules.home-manager
      localFlake.inputs.nix-index-database.nixosModules.default
      localFlake.inputs.sops-nix.nixosModules.sops
      localFlake.inputs.spicetify-nix.nixosModules.spicetify
      localFlake.inputs.stylix.nixosModules.stylix
      (localFlake.inputs.import-tree ./_biapy)
    ];
  };
in
{
  flake-file.inputs = {
    home-manager = {
      url = mkDefault "github:nix-community/home-manager";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
    };
    sops-nix = {
      url = mkDefault "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = mkDefault "nixpkgs";
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
    modules.nixos = {
      default = config.flake.modules.nixos.biapy;
      biapy = biapyNixOSModule localFlake;
      biapyUsers = biapyUsersNixOSModule localFlake;
    };

    nixosModules = config.flake.modules.nixos;

    tests = {
      "modules.nixos" = {
        "test: declares modules.nixos.biapy" = {
          expr = config.flake.modules.nixos ? biapy;
          expected = true;
        };

        "test: declares modules.nixos.default" = {
          expr = config.flake.modules.nixos ? default;
          expected = true;
        };
      };
    };
  };
}
