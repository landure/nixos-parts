/**
  # Nix channels

  Registers flake inputs as channels.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [nix.channels @ Home Manager Documentation](https://nix-community.github.io/home-manager/options.xhtml#opt-nix.channels).
  - [nix.channels @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=nix.channels.).
*/
{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.presets.channels;
in
{
  options.biapy.presets.channels.enable = mkEnableOption "Nix channels";

  config = mkIf cfg.enable {
    nix.channels = { inherit (inputs) nixpkgs nixpkgs-unstable; };
  };
}
