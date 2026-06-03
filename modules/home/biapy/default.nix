{
  config,
  inputs,
  lib,
  moduleLocation,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mkDefault
    mkOption
    types
    ;
in
{
  imports = [
    (inputs.flake-parts.flakeModules.modules or { })
    (inputs.home-manager.flakeModules.home-manager or { })
  ];

  options.flake.biapy.home = mkOption {
    type = types.lazyAttrsOf types.deferredModule;
    default = { };
    apply = mapAttrs (
      k: v:
      let
        name = k;
        module = v;
      in
      {
        _class = "home";
        _file = "${toString moduleLocation}#biapy.modules.nixos.${name}";
        imports = [ module ];
      }
    );
    description = ''
      Biapy's Home Manager modules.

      You may use this for reusable pieces of configuration, service modules, etc.
    '';
  };

  config = {
    flake-file.inputs.home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = mkDefault "nixpkgs";
      };
    };

    flake = {
      modules.home = {
        biapy =
          { config, ... }:
          let
            biapy_home_modules = config.flake.biapy.home;
          in
          {
            imports = [
              biapy_home_modules
            ];
          };

        default = config.flake.modules.home.biapy;
      };

      homeModules.biapy = config.flake.modules.home.biapy;

      tests = {
        "modules.home" = {
          "test: declares flake.modules.home.biapy" = {
            expr = config.flake.modules.home ? biapy;
            expected = true;
          };

          "test: declares flake.modules.home.default" = {
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
  };
}
