{ lib, ... }:
let
  inherit (lib.modules) evalModules;

  rbwModule = ../../../../home/_biapy/programs/rbw.nix;

  evalRbw =
    {
      username ? "testuser",
      email ? "john@example.com",
      modules ? [ ],
    }:
    let
      stub = {
        options = {
          home.username = lib.mkOption {
            type = lib.types.str;
            default = username;
          };
          home.homeDirectory = lib.mkOption {
            type = lib.types.str;
            default = "/home/${username}";
          };
          biapy.user.identity = lib.mkOption {
            type = lib.types.submodule {
              options.email = lib.mkOption {
                type = lib.types.str;
                default = email;
              };
            };
            default = { };
          };
          programs.rbw = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
                settings = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        email = lib.mkOption {
                          type = lib.types.str;
                        };
                        base_url = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                        };
                        pinentry = lib.mkOption {
                          type = lib.types.nullOr lib.types.package;
                          default = null;
                        };
                      };
                    }
                  );
                  default = null;
                };
              };
            };
            default = { };
          };
        };
      };
    in
    (evalModules {
      modules = [
        stub
        rbwModule
      ]
      ++ modules;
    }).config;

  enabled = modules: (evalRbw { inherit modules; }).programs.rbw;
in
{
  flake.tests."home.biapy.programs.rbw" = {
    "test: rbw is disabled by default" = {
      expr = (evalRbw { }).programs.rbw.enable;
      expected = false;
    };

    "test: enabling rbw turns on the upstream program" = {
      expr =
        (enabled [
          {
            config.biapy.programs.rbw.enable = lib.mkForce true;
          }
        ]).enable;
      expected = true;
    };

    "test: email defaults to the user identity email" = {
      expr =
        (enabled [
          {
            config.biapy.programs.rbw.enable = lib.mkForce true;
          }
        ]).settings.email;
      expected = "john@example.com";
    };

    "test: email can be overridden" = {
      expr =
        (enabled [
          {
            config.biapy.programs.rbw.enable = lib.mkForce true;
            config.programs.rbw.settings.email = lib.mkForce "other@example.com";
          }
        ]).settings.email;
      expected = "other@example.com";
    };

    "test: base_url defaults to the vaultwarden instance" = {
      expr =
        (enabled [
          {
            config.biapy.programs.rbw.enable = lib.mkForce true;
          }
        ]).settings.base_url;
      expected = "https://vaultwarden.biapy.fr/";
    };

    "test: settings are unset when rbw is disabled" = {
      expr = (evalRbw { }).programs.rbw.settings;
      expected = null;
    };
  };
}
