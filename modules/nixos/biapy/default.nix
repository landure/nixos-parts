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

  biapy.modules.nixos = self.biapy.modules.nixos;
in
{

  imports = [
    (inputs.flake-parts.flakeModules.modules or { })
  ];

  options.flake.biapy.modules.nixos = mkOption {
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
          _:
          {
            imports = [
              biapy.modules.nixos
            ];
          };

        default = self.modules.nixos.biapy;
      };

      tests = {
        "modules.nixos: declares biapy" = {
          expr = self.modules.nixos ? biapy;
          expected = true;
        };

        "modules.nixos: default is biapy" = {
          expr = self.modules.nixos.default == self.modules.nixos.biapy;
          expected = true;
        };
      };
    };
  };
}
