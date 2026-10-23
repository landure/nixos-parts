/**
  # Spicetify

  Spicetify is a command-line tool to customize Spotify.

  Requires `biapy-parts.overlays.default`, defined in `module/flake/pkgs-by-name.nix`.

  ## 🛠️ Tech Stack

  - [Spicetify homepage](https://spicetify.app/)
    ([Spicetify @ GitHub](https://github.com/spicetify/cli)).
  - [Spotify homepage](https://spotify.com/).
  - [Spicetify-nix](https://gerg-l.github.io/spicetify-nix/)
    ([Spicetify-nix @ GitHub](https://github.com/Gerg-L/spicetify-nix)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.spotify-player @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/spotify-player.html).
  - [programs.spotify-player @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.spotify-player.).

  ### 🎨 Stylix

  - [Spicetify](https://nix-community.github.io/stylix/options/modules/spicetify.html).

  ## 🙇 Acknowledgements

  - [Spicetify-Nix @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Spicetify-Nix).
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

  spicePkgs = pkgs.spicetify-nix;

  cfg = config.biapy.programs.spicetify;
in
{
  options = {
    biapy.programs.spicetify.enable = mkEnableOption "Spicetify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = mkDefault true;
      enabledCustomApps = with spicePkgs.apps; [
        ncsVisualizer
        marketplace
        reddit
      ];
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        aiBandBlocker # Automatically skip any known-AI artists
        allOfArtist # Create a playlist with all songs of an artist
        autoSkipVideo # Skip Video playback (ads and stuff)
        autoVolume # Automatically adjust volume over long periods of time, to reduce ear strain.
        copyToClipboard # Adds an option in the context menu to copy a song's name to your clipboard.
        focusMode # Creates a distraction-free listening experience with only album art visible.
        goToSong # Adds an option to the profile menu to go to the currently playing song or playlist.
        hidePodcasts # Remove everything from the spotify UI relating to podcasts.
        history # Adds a page that shows your listening history.
        listPlaylistsWithSong # Adds an option to the context menu for songs to show all of your account's playlists which contain that song.
        playNext # Add track to the top of the queue.
        playlistIcons # Give your playlists icons in the left sidebar.
        playlistIntersection # Compare two playlists, and create a new playlist containing their common songs, or only the songs unique to one playlist.
        powerBar # Spotlight-like search bar for spotify.
        privateSession # Always start Spotify with Private Session active.
        showQueueDuration # Show the total length of all songs currently queued.
        shuffle # shuffle+ (special characters are sanitized out of extension names)
        sideHide # Hides the sidebar (Friends Activity & Now Playing) and associated action buttons.
        skipOrPlayLikedSongs # Set spotify to automatically skip liked songs, or to only play liked songs.
        trashbin # Throw artists or songs in the trash, and permanently skip them.
        ytVideo # Search and watch YouTube videos for Spotify songs without ads, cookies, or tracking.
      ];

      # theme = spicePkgs.themes.catppuccin;
      # colorScheme = "mocha";
    };
  };
}
