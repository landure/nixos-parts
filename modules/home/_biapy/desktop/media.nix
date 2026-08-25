/**
  # GUI Media tools

  Movies and music tools.

  ## 🛠️ Tech Stack

  - [Handbrake homepage](https://handbrake.fr/)
    ([Handbrake @ GitHub](https://github.com/HandBrake/HandBrake)).
  - [Spotify homepage](https://spotify.com/).
  - [Spicetify-nix](https://gerg-l.github.io/spicetify-nix/)
    ([Spicetify-nix @ GitHub](https://github.com/Gerg-L/spicetify-nix)).
  - [VLC media player homepage](https://www.videolan.org/vlc/).

  ### Removed

  - [Jellyfin MPV Shim @ GitHub](https://github.com/jellyfin/jellyfin-mpv-shim):
    it's a web app that always run in the background.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.spotify-player @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.spotify-player.enable).
  - [services.jellyfin-mpv-shim @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.jellyfin-mpv-shim.enable).

  ### 🎨 Stylix

  - [Spicetify](https://nix-community.github.io/stylix/options/modules/spicetify.html).

  ## 🙇 Acknowledgements

  - [Spicetify-Nix @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Spicetify-Nix).
*/
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

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

    programs.spotify-player.enable = mkDefault (!config.programs.spicetify.enable);

    # services.jellyfin-mpv-shim.enable = mkDefault true;

    programs.spicetify = {
      enable = mkDefault true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];

      # theme = spicePkgs.themes.catppuccin;
      # colorScheme = "mocha";
    };

    biapy.system.unfree.allow = [
      "spicetify-cli"
      "spotify"
      "spicetify-Default"
    ];
  };
}
