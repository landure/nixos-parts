{ self, ... }:
{
  flake = {
    homeModules = {
      biapy = { };

      default = self.homeModules.biapy;
    };

    tests = {
      "homeModules: declares biapy" = {
        expr = self.homeModules ? biapy;
        expected = true;
      };

      "homeModules: default is biapy" = {
        expr = self.homeModules.default == self.homeModules.biapy;
        expected = true;
      };
    };
  };
}
