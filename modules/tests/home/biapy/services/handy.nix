{
  lib,
  inputs,
  self,
  ...
}:
let
  inherit (lib.modules) evalModules;

  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [ self.overlays.default ];
  };

  handyModule = ../../../../home/_biapy/services/handy.nix;

  stub = {
    options = {
      home.packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };
      wayland.windowManager = {
        hyprland.settings = lib.mkOption {
          type = lib.types.attrset;
          default = { };
        };
        sway.config = lib.mkOption {
          type = lib.types.attrset;
          default = {
            modifier = "Super";
          };
        };
      };
      systemd.user.services = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
        default = { };
      };
    };
  };

  evalHandy =
    modules:
    (evalModules {
      specialArgs = { inherit pkgs; };
      modules = [
        stub
        handyModule
      ]
      ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.services.handy" = {
    "test: disabled by default" = {
      expr = (evalHandy [ ]).biapy.services.handy.enable;
      expected = false;
    };

    "test: installs handy package when enabled" = {
      expr = map lib.getName (evalHandy [ { biapy.services.handy.enable = true; } ]).home.packages;
      expected = [
        "handy"
        "wtype"
      ];
    };

    "test: installs no packages when disabled" = {
      expr = (evalHandy [ ]).home.packages;
      expected = [ ];
    };

    "test: configures handy systemd user service when enabled" = {
      expr = (evalHandy [ { biapy.services.handy.enable = true; } ]).systemd.user.services.handy;
      expected = {
        Unit = {
          Description = "Handy speech-to-text service";
          After = [ "graphical-session.target" "tray.target" ];
          PartOf = [ "graphical-session.target" ];
          Requires = ["tray.target"];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.unstable.handy} --start-hidden";
          Restart = "on-failure";
        };
      };
    };

    "test: configures no systemd user service when disabled" = {
      expr = (evalHandy [ ]).systemd.user.services;
      expected = { };
    };
  };
}
