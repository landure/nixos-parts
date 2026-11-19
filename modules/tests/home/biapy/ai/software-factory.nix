{ lib, ... }:
let
  inherit (lib.modules) evalModules;

  softwareFactoryModule = ../../../../home/_biapy/ai/software-factory.nix;

  # Stub the modules the preset turns on, so the test only exercises the
  # preset wiring and not the whole home module tree.
  stub = {
    options = {
      biapy = {
        ai = {
          agent-skills.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          mcp-servers.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          skills.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
        skills = {
          cloudflare-security-audit-skill.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          guard-skills.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          hypothesis-debugging.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          jeffallan-claude-skills.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          mattpocock-skills.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          ponytail.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
    };
  };

  evalSoftwareFactory =
    {
      modules ? [ ],
    }:
    (evalModules {
      modules = [
        stub
        softwareFactoryModule
      ]
      ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.ai.software-factory" = {
    "test: the preset is disabled by default" = {
      expr = (evalSoftwareFactory { }).biapy.ai.software-factory.enable;
      expected = false;
    };

    "test: enabling the preset turns on the hypothesis-debugging skill" = {
      expr =
        (evalSoftwareFactory {
          modules = [
            {
              config.biapy.ai.software-factory.enable = lib.mkForce true;
            }
          ];
        }).biapy.skills.hypothesis-debugging.enable;
      expected = true;
    };

    "test: enabling the preset turns on the AI agent skills" = {
      expr =
        (evalSoftwareFactory {
          modules = [
            {
              config.biapy.ai.software-factory.enable = lib.mkForce true;
            }
          ];
        }).biapy.ai.skills.enable;
      expected = true;
    };
  };
}
