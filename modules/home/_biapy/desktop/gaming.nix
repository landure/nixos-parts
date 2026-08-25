/**
  # Gaming

  Steam is a commercial gaming platform.

  ## 🛠️ Tech Stack

  - [Steam homepage](https://store.steampowered.com/about/).
  - [GameHub @ GitHub](https://github.com/tkashkin/gamehub).
  - [Heroic Games Launcher homepage](https://heroicgameslauncher.com/)
    ([Heroic Games Launcher @ GitHub](https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher)).
  - [GE-Proton @ GitHub](https://github.com/GloriousEggroll/proton-ge-custom).
  - [Linux GPU Control Application (LACT) @ GitHub](https://github.com/ilya-zlobintsev/LACT).
  - [protontricks @ GitHub](https://github.com/Matoking/protontricks).
  - [umu @ GitHub](https://github.com/Open-Wine-Components/umu-launcher).
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
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.desktop.gaming;

  hasAmdGpu = config.hardware.facter.detected.graphics.amd.enable;
  hasNvidiaGpu = config.hardware.facter.detected.graphics.nvidia.enable;
in
{
  options = {
    biapy.desktop.gaming = {
      enable = mkEnableOption "gaming tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        gamehub
        heroic
        protontricks
        umu-launcher
      ]
      ++ (optional (!osConfig.programs.steam.enable) pkgs.steam)
      ++ (optional (hasAmdGpu || hasNvidiaGpu) pkgs.lact);
  };
}
