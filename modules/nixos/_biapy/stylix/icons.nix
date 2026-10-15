/**
  # 🎨 Stylix

  Stylix is a comprehensive theming framework for the Nix ecosystem that
  automatically applies consistent color schemes, wallpapers,
  and fonts across multiple platforms and applications.
  It provides a unified configuration interface that themes over 40
  applications using a single source of truth for aesthetic settings.

  ## 🛠️ Tech Stack

  - [Stylix homepage](https://nix-community.github.io/stylix/)
    ([Stylix @ GitHub](https://github.com/nix-community/stylix)).

  ### 🎨 Icon themes

  - [Adwaita icon theme @ GNOME's GitLab](https://gitlab.gnome.org/GNOME/adwaita-icon-theme).
  - [Colloid icon theme @ GitHub](https://github.com/vinceliuice/colloid-icon-theme).
  - [Fluent icon theme @ GitHub](https://github.com/vinceliuice/Fluent-icon-theme).
  - [Humanity icon theme @ Launchpad](https://launchpad.net/humanity/).
  - [La Capitaine icon theme homepage](https://github.com/keeferrourke/la-capitaine-icon-theme)
    ([La Capitaine icon theme @ GitHub](https://krourke.org/projects/art/la-capitaine-icon-theme)).
  - [Mate icon theme @ GitHub](https://github.com/mate-desktop/mate-icon-theme).
  - [Numix Project homepage](https://numixproject.github.io/).
    - [Numix icon theme @ GitHub](https://github.com/numixproject/numix-icon-theme).
    - [Numix Circle icon theme @ GitHub](https://github.com/numixproject/numix-icon-theme-circle).
  - [Papirus icon theme @ GitHub](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/).
  - [Pop icon theme @ GitHub](https://github.com/pop-os/icon-theme).
  - [Tango icon theme @ FreeDesktop](https://tango.freedesktop.org/Tango_Icon_Library).
  - [Tela Circle Icon Theme @ GitHub](https://github.com/vinceliuice/Tela-circle-icon-theme).

  ## 📝 Documentation

  ### 🎨 Stylix

  - [stylix.icons](https://nix-community.github.io/stylix/options/platforms/nixos.html#stylixiconsdark).

  ## 🙇 Acknowledgements

  - [Theming @ vlaci's nix knowledge base](https://vlaci.github.io/nix.org/posts/theming).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) attrNames;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;

  cfg = config.biapy.stylix.icons;

  iconThemes = {
    adwaita = {
      package = pkgs.adwaita-icon-theme;
      dark = "Adwaita";
      light = "Adwaita";
    };
    arc = {
      package = pkgs.arc-icon-theme;
      dark = "Arc";
      light = "Arc";
    };
    colloid = {
      packages = pkgs.colloid-icon-theme;
      dark = "Colloid-Dark";
      light = "Colloid-Light";
    };
    dracula = {
      packages = pkgs.dracula-icon-theme;
      dark = "Dracula";
      light = "Dracula";
    };
    elementary-xfce-icon-theme = {
      packages = pkgs.elementary-xfce-icon-theme;
      dark = "elementary-xfce-dark";
      light = "elementary-xfce";
    };
    faba = {
      packages = pkgs.faba-icon-theme;
      dark = "Faba-dark";
      light = "Faba-light";
    };
    fluent = {
      packages = pkgs.fluent-icon-theme;
      dark = "Fluent-dark";
      light = "Fluent-light";
    };
    humanity = {
      package = pkgs.humanity-icon-theme;
      dark = "Humanity-Dark";
      light = "Humanity";
    };
    kanagawa = {
      package = pkgs.kanagawa-icon-theme;
      dark = "Kanagawa";
      light = "Kanagawa";
    };
    kora = {
      package = pkgs.kora-icon-theme;
      dark = "kora";
      light = "kora-light";
    };
    la-capitaine = {
      package = pkgs.la-capitaine-icon-theme;
      dark = "la-capitaine-icon-theme";
      light = "la-capitaine-icon-theme";
    };
    mate = {
      package = pkgs.mate-icon-theme;
      dark = "mate";
      light = "mate";
    };
    moka = {
      package = pkgs.moka-icon-theme;
      dark = "Moka";
      light = "Moka";
    };
    numix = {
      package = pkgs.numix-icon-theme;
      dark = "Numix";
      light = "Numix-Light";
    };
    numix-circle = {
      package = pkgs.numix-icon-theme-circle;
      dark = "Numix-Circle";
      light = "Numix-Circle-Light";
    };
    numix-square = {
      package = pkgs.numix-icon-theme-square;
      dark = "Numix-Square";
      light = "Numix-Square-Light";
    };
    papirus = {
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    pop = {
      package = pkgs.pop-icon-theme;
      dark = "Pop";
      light = "Pop";
    };
    qogir = {
      package = pkgs.qogir-icon-theme;
      dark = "Qogir-Dark";
      light = "Qogir-Light";
    };
    qogir-manjaro = {
      package = pkgs.qogir-icon-theme;
      dark = "Qogir-Manjaro-Dark";
      light = "Qogir-Manjaro-Light";
    };
    qogir-ubuntu = {
      package = pkgs.qogir-icon-theme;
      dark = "Qogir-Ubuntu-Dark";
      light = "Qogir-Ubuntu-Light";
    };
    reversal = {
      package = pkgs.reversal-icon-theme;
      dark = "Reversal-dark";
      light = "Reversal";
    };
    tango = {
      package = pkgs.tango-icon-theme;
      dark = "Tango";
      light = "Tango";
    };
    tela-circle = {
      package = pkgs.tela-circle-icon-theme;
      dark = "Tela-circle-dark";
      light = "Tela-circle-light";
    };
  };
in
{
  options.biapy.stylix.icons = {
    enable = mkEnableOption "stylix theming";

    theme = mkOption {
      type = enum (attrNames iconThemes);
      description = "icon theme";
      default = "papirus";
    };
  };

  config = mkIf cfg.enable {

    stylix.icons = {
      enable = mkDefault true;
      package = mkDefault iconThemes.${cfg.theme}.package;
      dark = mkDefault iconThemes.${cfg.theme}.dark;
      light = mkDefault iconThemes.${cfg.theme}.light;
    };
  };
}
