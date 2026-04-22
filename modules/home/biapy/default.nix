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
          { self, ... }:
          let
            biapy_home_modules = self.biapy.home;
          in
          {
            imports = [
              biapy_home_modules
            ];
          };

        default = self.modules.home.biapy;
      };

      tests = {
        "modules.home" = {
          "test: declares biapy" = {
            expr = self.modules.home ? biapy;
            expected = true;
          };

          "test: declares default" = {
            expr = self.modules.home ? default;
            expected = true;
          };
        };
      };
    };
  };
}
