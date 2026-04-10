{ self, ... }:
{
  flake.nixosModules = {
    biapy = { };

    default = self.homeModules.biapy;
  };
}
