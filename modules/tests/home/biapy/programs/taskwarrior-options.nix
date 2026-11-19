{ inputs, lib, ... }:
let
  inherit (lib.modules) evalModules;

  taskwarriorModule = ../../../../home/_biapy/programs/taskwarrior.nix;

  evalTaskwarrior =
    {
      modules ? [ ],
    }:
    let
      stub = {
        options = {
          home = {
            username = lib.mkOption {
              type = lib.types.str;
              default = "testuser";
            };
            homeDirectory = lib.mkOption {
              type = lib.types.str;
              default = "/home/testuser";
            };
            packages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
            };
          };
          xdg = {
            configHome = lib.mkOption {
              type = lib.types.str;
              default = "/home/testuser/.config";
            };
            dataHome = lib.mkOption {
              type = lib.types.str;
              default = "/home/testuser/.local/share";
            };
          };
          programs.taskwarrior = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
                package = lib.mkOption {
                  type = lib.types.nullOr lib.types.package;
                  default = null;
                };
                colorTheme = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                config = lib.mkOption {
                  type = lib.types.attrsOf lib.types.anything;
                  default = { };
                };
                dataLocation = lib.mkOption {
                  type = lib.types.str;
                  default = "/home/testuser/.local/share/task";
                };
                extraConfig = lib.mkOption {
                  type = lib.types.lines;
                  default = "";
                };
              };
            };
            default = { };
          };
        };
      };
    in
    (evalModules {
      specialArgs = {
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
        };
      };
      modules = [
        stub
        taskwarriorModule
      ]
      ++ modules;
    }).config;

  enabled = modules: (evalTaskwarrior { inherit modules; }).programs.taskwarrior;
in
{
  flake.tests."home.biapy.programs.taskwarrior" = {
    "test: taskwarrior is disabled by default" = {
      expr = (evalTaskwarrior { }).programs.taskwarrior.enable;
      expected = false;
    };

    "test: enabling taskwarrior turns on the upstream program" = {
      expr =
        (enabled [
          {
            config.biapy.programs.taskwarrior.enable = lib.mkForce true;
          }
        ]).enable;
      expected = true;
    };

    "test: the upstream package defaults to taskwarrior3" = {
      expr =
        (package: {
          inherit (package) pname;
          isVersion3 = lib.hasPrefix "3." package.version;
        })
          (enabled [
            {
              config.biapy.programs.taskwarrior.enable = lib.mkForce true;
            }
          ]).package;
      expected = {
        pname = "taskwarrior";
        isVersion3 = true;
      };
    };

    "test: a dark colour theme is used by default" = {
      expr =
        (enabled [
          {
            config.biapy.programs.taskwarrior.enable = lib.mkForce true;
          }
        ]).colorTheme;
      expected = "dark-blue-256";
    };

    "test: the minimal report only lists pending tasks" = {
      expr =
        (enabled [
          {
            config.biapy.programs.taskwarrior.enable = lib.mkForce true;
          }
        ]).config.report.minimal.filter;
      expected = "status:pending";
    };

    "test: projects are empty by default" = {
      expr =
        (enabled [
          {
            config.biapy.programs.taskwarrior.enable = lib.mkForce true;
          }
        ]).config.next.projects;
      expected = "";
    };

    "test: projects are joined with commas" = {
      expr =
        (enabled [
          {
            config.biapy.programs.taskwarrior.enable = lib.mkForce true;
            config.biapy.programs.taskwarrior.projects = lib.mkForce [
              "home"
              "work"
            ];
          }
        ]).config.next.projects;
      expected = "home,work";
    };
  };
}
