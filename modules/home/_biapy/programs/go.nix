/**
  # Go

  ## 🛠️ Tech Stack

  - [Go homepage](https://go.dev/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.go @ NixOS reference](https://search.nixos.org/options?query=programs.go&source=home_manager).
  - [programs.go @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.enable).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.go;
in
{
  options = {
    biapy.programs.go.enable = mkEnableOption "Go";
  };

  config = mkIf cfg.enable {
    programs = {
      go = {
        enable = mkDefault true;
        telemetry.mode = mkDefault "off";
      };
    };
  };
}
