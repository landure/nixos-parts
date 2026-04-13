{ self, ... }:
{
  flake = {
    nixosModules = {
      biapy = { };

      default = self.homeModules.biapy;
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
