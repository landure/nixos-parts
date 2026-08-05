/**
  # mandoc & Man pages

  mandoc is a suite of tools compiling mdoc,
  the roff macro language of choice for BSD manual pages, and man,
  the predominant historical language for UNIX manuals.

  ## 🛠️ Tech Stack

  - [mandoc homepage](https://mandoc.bsd.lv/).
  - [less homepage](https://www.greenwoodsoftware.com/less/).
  - [most homepage](https://jedsoft.org/most/)
    ([most @ GitHub](https://github.com/jedsoft/most))

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.less @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.less.enable).
  - [programs.man @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.man.enable).
  - [home.sessionVariables @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-home.sessionVariables).
  - [home.sessionSearchVariables @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-home.sessionSearchVariables).

  ## 🙇 Acknowledgements

  - [Groff + most change in behaviour @ Arch Linux BBS](https://bbs.archlinux.org/viewtopic.php?id=287185).
  - [GNU roff (groff) @ GNU](https://www.gnu.org/software/groff/).
  - [How To Colorize Man Pages @ Bash Prompt](https://bash-prompt.net/guides/bash-colorize-man/).
  - [Colors in Man Pages @ Stack Exchange Unix & Linux](https://unix.stackexchange.com/questions/119/colors-in-man-pages/147#147).
  - [Color output in console @ ArchLinux Wiki](https://wiki.archlinux.org/title/Color_output_in_console).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;

  cfg = config.biapy.programs.man;

  pagers = {
    less = "${getExe programs.less.package} --use-color -Dd+r -Du+b";
    most = "${getExe pkgs.most}";
  };
in
{
  options = {
    biapy.programs.man = {
      enable = mkEnableOption "man pages";

      pager = mkOption {
        type = enum [
          "less"
          "most"
        ];
        default = "less";
        description = ''
          pager to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Set "most" as "man" pager to colorize man pages.
    home.sessionVariables = {
      MANROFFOPT = mkDefault "-P -c";
      MANPAGER = mkDefault pagers."${cfg.pager}";
    };

    programs = {
      less.enable = mkDefault true;

      man = {
        enable = mkDefault true; # enable manual pages and the man command.
        # generate the manual page index caches using mandb(8).
        # This allows searching for a page or keyword using utilities like apropos(1).
        generateCaches = mkDefault true;
      };
    };
  };
}
