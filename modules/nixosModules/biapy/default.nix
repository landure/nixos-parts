{
  flake-parts-lib,
  self,
  withSystem,
  ...
}:
let
  inherit (flake-parts-lib) importApply;

in
{
  flake = {
    nixosModules = {
      biapy = { };

      default = self.nixosModules.biapy;
    };

    tests = {
      "nixosModules: declares biapy" = {
        expr = self.nixosModules ? biapy;
        expected = true;
      };

      "nixosModules: default is biapy" = {
        expr = self.nixosModules.default == self.nixosModules.biapy;
        expected = true;
      };
    };
  };
}
