/**
  # Lutris

  Lutris helps to install and play video games from all eras and from most
  gaming systems.
  By leveraging and combining existing emulators, engine re-implementations,
  and compatibility layers,
  it gives you a central interface to launch all your games.

  ## 🛠️ Tech Stack

  - [Lutris homepage](https://lutris.net/)
    ([Lutris @ GitHub](https://github.com/lutris/lutris)).

  ## 📝 Documentation

  - [programs.lutris @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lutris.enable).
  - [programs.lutris @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.lutris.).
*/
{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.programs.lutris;
in
{
  options = {
    biapy.programs.lutris = {
      enable = mkEnableOption "Lutris";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dolphin ];
    programs.lutris = {
      enable = mkDefault true;
      steamPackage = mkDefault (
        if osConfig.programs.steam.enable or false then
          osConfig.programs.steam.package
        else
          pkgs.steam
      );
    };
  };
}
