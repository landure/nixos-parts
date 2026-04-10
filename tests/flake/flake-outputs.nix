{ self, ... }:
{
  flake.tests.flakeOuputs = {
    "nixosModules: declares biapy" = {
      expr = self.nixosModules ? biapy;
      expected = true;
    };

    "nixosModules: default is biapy" = {
      expr = self.nixosModules.default == self.nixosModules.biapy;
      expected = true;
    };

    "homeModules: declares biapy" = {
      expr = self.homeModules ? biapy;
      expected = true;
    };

    "homeModules: default is biapy" = {
      expr = self.homeModules.default == self.homeModules.biapy;
      expected = true;
    };
  };
}
