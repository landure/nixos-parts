{ lib, ... }:
let
  gumModule = ../../../../home/_biapy/programs/gum.nix;

  evalGum =
    {
      modules ? [ ],
    }:
    (lib.modules.evalModules {
      modules = [
        {
          options = {
            home.username = lib.mkOption {
              type = lib.types.str;
              default = "testuser";
            };
            home.homeDirectory = lib.mkOption {
              type = lib.types.str;
              default = "/home/testuser";
            };
            biapy.ai.skills.skills = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            home.packages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
            };
          };
        }
        gumModule
      ]
      ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.programs.gum" = {
    "test: gum is disabled by default" = {
      expr = (evalGum { }).biapy.programs.gum.enable;
      expected = false;
    };

    "test: enabling gum installs the package" = {
      expr =
        (evalGum {
          modules = [ { config.biapy.programs.gum.enable = lib.mkForce true; } ];
        }).home.packages != [ ];
      expected = true;
    };
  };
}
