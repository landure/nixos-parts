/**
  # yt-dlp

  `yt-dlp` is a feature-rich command-line audio/video downloader with support for thousands of sites.
  The project is a fork of youtube-dl based on the now inactive youtube-dlc.

  ## 🛠️ Tech Stack

  - [yt-dlp @ GitHub](https://github.com/yt-dlp/yt-dlp).
  - [aria2 homepage](https://aria2.github.io/)
    ([aria2 @ GitHub](https://github.com/aria2/aria2)).

  ## 📝 Documentation

  - [yt-dlp configuration](https://github.com/yt-dlp/yt-dlp#configuration).

  ### 🏠 Home Manager

  - [programs.aria2 @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aria2.enable).
  - [programs.yt-dlp @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yt-dlp.enable).
  - [home-manager/modules/programs/yt-dlp.nix @ GitHub](https://github.com/nix-community/home-manager/blob/master/modules/programs/yt-dlp.nix).
*/
{
  config,
  lib,
  pkgs-unstable,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.yt-dlp;
in
{
  options = {
    biapy.programs.yt-dlp = {
      enable = mkEnableOption "yt-dlp";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      aria2 = {
        enable = mkDefault true;
        package = pkgs-unstable.aria2;
        settings = {
          ftp-pasv = true;
        };
      };

      yt-dlp = {
        enable = mkDefault true;

        package = mkDefault pkgs-unstable.yt-dlp;

        settings = {
          embed-thumbnail = mkDefault true;
          embed-subs = mkDefault true;
          sub-langs = mkDefault "en,fr";
          downloader = mkDefault (getExe config.programs.aria2.package);
          downloader-args = mkDefault "aria2c:'-c -x8 -s8 -k1M'";
        };
      };
    };
  };
}
