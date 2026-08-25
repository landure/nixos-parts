/**
  # GUI Media tools

  Movies and music tools.

  ## 🛠️ Tech Stack

  - [Handbrake homepage](https://handbrake.fr/)
    ([Handbrake @ GitHub](https://github.com/HandBrake/HandBrake))
    is an open-source video transcoder.
  - [Spotify homepage](https://spotify.com/).
  - [Spicetify homepage](https://spicetify.app/)
    ([Spicetify @ GitHub](https://github.com/spicetify/cli))
    is a command-line tool to customize spotify.
  - [VLC media player homepage](https://www.videolan.org/vlc/).

  ### Removed

  - [Jellyfin MPV Shim @ GitHub](https://github.com/jellyfin/jellyfin-mpv-shim):
    it's a web app that always run in the background.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.spotify-player @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.spotify-player.enable).
  - [services.jellyfin-mpv-shim @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.jellyfin-mpv-shim.enable).
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

  cfg = config.biapy.desktop.media;
in
{
  options = {
    biapy.desktop.media = {
      enable = mkEnableOption "Music and video tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      handbrake
      vlc
    ];

    # enable spotify if spicetify is manually removed.
    programs.spotify-player.enable = mkDefault (!config.biapy.programs.spicetify.enable);

    # services.jellyfin-mpv-shim.enable = mkDefault true;

    biapy.programs.spicetify.enable = mkDefault true;
  };
}
