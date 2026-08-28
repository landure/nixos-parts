/**
  # Git Alias

  Git Alias is a collection of git version control alias settings that can help
  work faster and better.
  Git Alias provides short aliases such as `s` for status,
  command aliases such as `chart` and `churn`,
  lookup aliases such as `whois` and `whatis`,
  workflow aliases such as `topic-begin` for feature branch development, and more.

  ## 🛠️ Tech Stack

  - [Git homepage](https://git-scm.com/).
  - [Git Alias @ GitHub](https://github.com/GitAlias/gitalias).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;
  inherit (pkgs) fetchurl;

  cfg = config.biapy.programs.gitalias;

  gitalias_path = "${config.xdg.configHome}/gitalias/gitalias.txt";

in
{
  options.biapy.programs.gitalias.enable = mkEnableOption "Git utilities";

  config = mkIf cfg.enable {
    # link gitalias.txt from store to
    # $XDG_CONFIG_HOME/gitalias/gitalias.txt
    home.file = {
      ${gitalias_path}.source = mkDefault (fetchurl {
        url = "https://raw.githubusercontent.com/GitAlias/gitalias/7653169af41a9fa93d6f5c5e2aedb4c7ce801840/gitalias.txt";
        hash = "sha256-S2yrTL2C6sowtKj626N+PMbKRuqaYOkpvOAYs/qupa8=";
      });
    };

    # tell git to include gitalias.txt
    programs.git = {
      enable = mkDefault true;
      includes = [
        { path = "${config.xdg.configHome}/gitalias/gitalias.txt"; }
      ];
    };
  };
}
