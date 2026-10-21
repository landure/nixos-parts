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

  networkModule = ../../../../home/_biapy/console/network.nix;

  stub = {
    options = {
      home.packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };
      home.shellAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
      biapy.programs.trippy.enable = lib.mkEnableOption "trippy";
    };
  };

  evalNetwork =
    modules:
    (evalModules {
      specialArgs = { inherit pkgs; };
      modules = [
        stub
        networkModule
      ]
      ++ modules;
    }).config;
in
{
  flake.tests."home.biapy.console.network" = {
    "test: disabled by default" = {
      expr = (evalNetwork [ ]).biapy.console.network.enable;
      expected = false;
    };

    "test: installs network packages when enabled" = {
      expr = map lib.getName (evalNetwork [ { biapy.console.network.enable = true; } ]).home.packages;
      expected = [
        "dogedns"
        "doggo"
        "gping"
        "nbping"
        "netop"
        "snitch"
        "trippy"
        "wtfis"
        "netwatch-tui"
        "cloudflare-speed-cli"
        "quien"
        "pktz"
        "wtfi2"
      ];
    };

    "test: installs no packages when disabled" = {
      expr = (evalNetwork [ ]).home.packages;
      expected = [ ];
    };

    "test: sets netop shell alias when enabled" = {
      expr = (evalNetwork [ { biapy.console.network.enable = true; } ]).home.shellAliases.netop;
      expected = "sudo ${lib.getExe pkgs.netop}";
    };

    "test: sets pktz shell alias when enabled" = {
      expr = (evalNetwork [ { biapy.console.network.enable = true; } ]).home.shellAliases.pktz;
      expected = "sudo ${lib.getExe pkgs.biapy-parts.pktz}";
    };

    "test: sets no shell aliases when disabled" = {
      expr = (evalNetwork [ ]).home.shellAliases;
      expected = { };
    };

    "test: enables trippy when enabled" = {
      expr = (evalNetwork [ { biapy.console.network.enable = true; } ]).biapy.programs.trippy.enable;
      expected = true;
    };

    "test: does not enable trippy when disabled" = {
      expr = (evalNetwork [ ]).biapy.programs.trippy.enable;
      expected = false;
    };
  };
}
