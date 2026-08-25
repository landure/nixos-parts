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

  - [programs.spotify-player @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.spotify-player.enable).

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
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];

      # theme = spicePkgs.themes.catppuccin;
      # colorScheme = "mocha";
    };
  };
}
