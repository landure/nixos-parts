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
    mkOption
    types
    ;
in
{
  imports = [
    (inputs.flake-parts.flakeModules.modules or { })
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

      tests = {
        "modules.home" = {
          "test: declares biapy" = {
            expr = config.flake.modules.home ? biapy;
            expected = true;
          };

          "test: declares default" = {
            expr = config.flake.modules.home ? default;
            expected = true;
          };
        };
      };
    };
  };
}
