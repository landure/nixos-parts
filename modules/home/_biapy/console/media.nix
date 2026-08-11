/**
  # Media Tools

  ## 🛠️ Tech Stack

  - [castero @ GitHub](https://github.com/xgi/castero).
  - [pamixer @ GitHub](https://github.com/cdemoulins/pamixer).
  - [pulsemixer @ GitHub](https://github.com/GeorgeFilipkin/pulsemixer).
  - [PyRadio @ GitHub](https://github.com/coderholic/pyradio).
  - [radio-active @ GitHub](https://github.com/deep5050/radio-active).
  - [wiremix @ GitHub](https://github.com/tsowell/wiremix).

  ## 📝 Documentation

  - [programs.radio-active @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.radio-active.enable).
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
    biapy.console.media = {
      enable = mkEnableOption "command-line media tools";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      castero # Podcast player
      wiremix # Pipewire mixer
      # pamixer
      pulsemixer
      pyradio
    ];

    biapy.programs = {
      cava.enable = mkDefault true;
      mpv.enable = mkDefault true;
      yt-dlp.enable = mkDefault true;
    };

    programs = {
      radio-active.enable = mkDefault true;
    };
  };
}
