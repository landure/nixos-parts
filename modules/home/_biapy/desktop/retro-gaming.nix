/**
  # Retro Gaming

  ## 🛠️ Tech Stack

  - [Dolphin homepage](https://dolphin-emu.org/)
  - [Lutris homepage](https://lutris.net/)
    ([Lutris @ GitHub](https://github.com/lutris/lutris)).

  ## 📝 Documentation

  - [programs.lutris @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lutris.enable).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.desktop.retro-gaming;
in
{
  options = {
    biapy.desktop.retro-gaming = {
      enable = mkEnableOption "retro-gaming tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dolphin ];
    programs.lutris.enable = mkDefault true;
  };
}
