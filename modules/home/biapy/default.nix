{ self, ... }:
{
  flake = {
    modules.home = {
      biapy = _: { };

      default = self.modules.home.biapy;
    };

    tests = {
      "modules.home: declares biapy" = {
        expr = self.modules.home ? biapy;
        expected = true;
      };

      "modules.home: default is biapy" = {
        expr = self.modules.home.default == self.modules.home.biapy;
        expected = true;
      };
    };
  };
}
