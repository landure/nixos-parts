/**
  # Facter

  ## 🛠️ Tech Stack

  - [NixOS Facter homepage](https://nix-community.github.io/nixos-facter/latest/)
    ([NixOS Facter @ GitHub](https://github.com/nix-community/nixos-facter)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [hardware.facter @ NixOS reference](https://search.nixos.org/options?query=hardware.facter.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.console.hardware;
in
{
  options = {
    biapy.console.hardware.enable = mkEnableOption "harware tools";
  };

  config = mkIf cfg.enable {
    environment.defaultPackages = with pkgs; [
      facter
      lshw
      nixos-facter
    ];
  };
}
