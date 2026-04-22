{
  inputs,
  lib,
  moduleLocation,
  self,
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
          { self, ... }:
          let
            biapy_nixos_modules = self.biapy.nixos;
          in
          {
            imports = [
              biapy_nixos_modules
            ];
          };

        default = self.modules.nixos.biapy;
      };

      tests = {
        "modules.nixos" = {
          "test: declares modules.nixos.biapy" = {
            expr = self.modules.nixos ? biapy;
            expected = true;
          };

          "test: declares modules.nixos.default" = {
            expr = self.modules.nixos ? default;
            expected = true;
          };
        };
      };
    };
  };
}
