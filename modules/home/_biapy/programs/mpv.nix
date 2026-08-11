/**
  # Media Tools

  ## 🛠️ Tech Stack

  - [mpv homepage](https://mpv.io/)
    ([mpv @ GitHub](https://github.com/mpv-player/mpv)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.mpv @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mpv.enable).

  ## 🙇 Acknowledgements

  - [Scripts I wrote that I use all the time @ Evan Hahn](https://evanhahn.com/scripts-i-wrote-that-i-use-all-the-time/).
  - [mpv Wiki](https://github.com/mpv-player/mpv/wiki).
  - [mpv @ Official NixOS Wiki](https://wiki.nixos.org/wiki/MPV).
  - [MPV @ NixOS Wiki](https://nixos.wiki/wiki/MPV).
  - [mpvScripts @ NixOS' Packages](https://search.nixos.org/packages?query=mpvScripts).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption;
  inherit (pkgs)
    mpv
    mpv-unwrapped
    mpvScripts
    ffmpeg-full
    ;

  cfg = config.biapy.programs.mpv;
in
{
  options = {
    biapy.programs.mpv.enable = mkEnableOption "command-line media tools";
  };

  config = mkIf cfg.enable {
    programs.mpv = {
      enable = mkDefault true;

      package = mkDefault (
        mpv.override {
          mpv-unwrapped = mpv-unwrapped.override {
            ffmpeg = ffmpeg-full;
            vapoursynthSupport = true;
            sixelSupport = true;
          };

          youtubeSupport = config.programs.yt-dlp.enable;
          scripts = with mpvScripts; [
            uosc
            sponsorblock
            mpris
          ];
        }
      );

      bindings = {
        # @see https://mpv.io/manual/stable/#input-key-bindings
        "h" = mkOptionDefault "seek -1";
        "j" = mkOptionDefault "seek -5";
        "k" = mkOptionDefault "seek +5";
        "l" = mkOptionDefault "seek +1";
        "space" = mkOptionDefault "cycle pause";
        "q" = mkOptionDefault "quit";

        WHEEL_UP = mkOptionDefault "seek 10";
        WHEEL_DOWN = mkOptionDefault "seek -10";
        "Alt+0" = mkOptionDefault "set window-scale 0.5";
      };

      config = {
        profile = mkDefault "gpu-hq";
        force-window = mkDefault true;
        ytdl-format = mkDefault "bestvideo+bestaudio";
        cache-default = mkDefault 4000000;
      };
      defaultProfiles = [
        "gpu-hq"
        "high-quality"
      ];
    };

    home.packages = [
      (pkgs.writeShellScriptBin "tuivid" ''
        # tuivid: mpv wrapper to play video in the terminal.
        # It’s cursed and I love it, even if I never use it.
        # see https://codeberg.org/EvanHahn/dotfiles/src/branch/main/home/bin/bin/tuivid
        set -e
        set -u
        set -o pipefail

        exec ${getExe config.programs.mpv.package} --quiet --vo=tct --vo-tct-256=yes --vo-tct-algo=plain --framedrop=vo "$@"
      '')

      (pkgs.writeShellScriptBin "tunes" ''
        # tunes uses mpv to play audio from a file. I use this all the time,
        # running tunes --shuffle ~/music.
        # see https://codeberg.org/EvanHahn/dotfiles/src/branch/main/home/bin/bin/tunes
        set -e
        set -u
        set -o pipefail

        exec ${getExe config.programs.mpv.package} --no-video --ytdl-format=worstaudio "$@"
      '')

      # (pkgs.writeShellScriptBin "radio" ''
      #   # radio is a little wrapper around some of my favorite internet radio stations.
      #   # radio lofi and radio salsa are two of my favorites.
      #   # I use this a few times a month.
      #   # see https://codeberg.org/EvanHahn/dotfiles/src/branch/main/home/bin/bin/radio
      #   set -e
      #   set -u
      #   set -o pipefail

      #   if [ "$1" == 'lofi' ]; then
      #     url='https://live.hunter.fm/lofi_low'
      #   elif [ "$1" == 'trance' ]; then
      #     url='http://ubuntu.hbr1.com:19800/trance.ogg'
      #   elif [ "$1" == 'salsa' ]; then
      #     url='https://latinasalsa.ice.infomaniak.ch/latinasalsa.mp3'
      #   elif [ "$1" == 'kfai' ]; then
      #     url='https://kfai.broadcasttool.stream/kfai-1'
      #   else
      #     echo "don't know $1" 1>&2
      #     exit 1
      #   fi

      #   exec ${getExe config.programs.mpv.package} --really-quiet "''${url}"
      # '')
    ];
  };
}
