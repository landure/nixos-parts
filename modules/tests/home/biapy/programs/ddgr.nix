{ lib, ... }:
let
  ddgrModule = ../../../../home/_biapy/programs/ddgr.nix;

  evalDdgr =
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
        ddgrModule
      ]
      ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.programs.ddgr" = {
    "test: ddgr is disabled by default" = {
      expr = (evalDdgr { }).biapy.programs.ddgr.enable;
      expected = false;
    };

    "test: enabling ddgr installs the package" = {
      expr =
        (evalDdgr {
          modules = [ { config.biapy.programs.ddgr.enable = lib.mkForce true; } ];
        }).home.packages != [ ];
      expected = true;
    };
  };
}
