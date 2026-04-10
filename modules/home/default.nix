{ self, ... }:
{
  flake.homeModules = {
    biapy = { };

    default = self.homeModules.biapy;
  };
}
