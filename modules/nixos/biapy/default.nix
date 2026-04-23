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

  options.flake.biapy.nixos = mkOption {
    type = types.lazyAttrsOf types.deferredModule;
    default = { };
    apply = mapAttrs (
      k: v:
      let
        name = k;
        module = v;
      in
      {
        _class = "nixos";
        _file = "${toString moduleLocation}#biapy.modules.nixos.${name}";
        imports = [ module ];
      }
    );
    description = ''
      Biapy's NixOS modules.

      You may use this for reusable pieces of configuration, service modules, etc.
    '';
  };

  config = {

    flake = {

      modules.nixos = {
        biapy =
          { config, ... }:
          let
            biapy_nixos_modules = config.flake.biapy.nixos;
          in
          {
            imports = [
              biapy_nixos_modules
            ];
          };

        default = config.flake.modules.nixos.biapy;
      };

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
  };
}
