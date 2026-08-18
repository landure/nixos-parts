/**
  # Media Tools

  ## 🛠️ Tech Stack

  - [castero @ GitHub](https://github.com/xgi/castero)
    is a TUI podcast client for the terminal.
  - [kew homepage](https://kewplayer.com/)
    ([kew @ GitHub](https://github.com/ravachol/kew))
    is an immersive and fast music player that allows to listen to music with privacy.
  - [mufetch @ GitHub](https://github.com/ashish0kumar/mufetch)
    is a Neofetch-style CLI for music.
  - [pulsemixer @ GitHub](https://github.com/GeorgeFilipkin/pulsemixer).
  - [PyRadio @ GitHub](https://github.com/coderholic/pyradio)
    is a Curses based internet radio player.
  - [radio-active @ GitHub](https://github.com/deep5050/radio-active)
    plays any radios around the globe right from the terminal ⚡.
  - [wiremix @ GitHub](https://github.com/tsowell/wiremix)
    is a simple TUI audio mixer for PipeWire.

  ## 📝 Documentation

  - [programs.radio-active @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.radio-active.enable).

  ## 🙇 Acknowledgements

  - [pamixer @ GitHub](https://github.com/cdemoulins/pamixer).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.console.media;

in
{
  options = {
    biapy.console.media.enable = mkEnableOption "command-line media tools";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      castero # Podcast player
      # pamixer
      mufetch
      pulsemixer
      pyradio
      wiremix # Pipewire mixer
    ];

    biapy.programs = {
      cava.enable = mkDefault true;
      radio-cli.enable = mkDefault true;
      mpv.enable = mkDefault true;
      yt-dlp.enable = mkDefault true;
    };

    programs = {
      radio-active.enable = mkDefault true;
    };
  };
}
