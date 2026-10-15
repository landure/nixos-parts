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
  - [Flat-Remix icon theme homepage](https://drasite.com/flat-remix)
    ([Flat-Remix icon theme @ GitHub](https://github.com/daniruiz/flat-remix)).
  - [Humanity icon theme @ Launchpad](https://launchpad.net/humanity/).
  - [La Capitaine icon theme homepage](https://github.com/keeferrourke/la-capitaine-icon-theme)
    ([La Capitaine icon theme @ GitHub](https://krourke.org/projects/art/la-capitaine-icon-theme)).
  - [Mate icon theme @ GitHub](https://github.com/mate-desktop/mate-icon-theme).
  - [Numix Project homepage](https://numixproject.github.io/).
    - [Numix icon theme @ GitHub](https://github.com/numixproject/numix-icon-theme).
    - [Numix Circle icon theme @ GitHub](https://github.com/numixproject/numix-icon-theme-circle).
  - [Nordzy icon theme @ GitHub](https://github.com/alvatip/Nordzy-icon).
  - [Papirus icon theme @ GitHub](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/).
  - [Papirus-Maia icon theme @ GitHub](https://github.com/Ste74/papirus-maia-icon-theme).
  - [Pop icon theme @ GitHub](https://github.com/pop-os/icon-theme).
  - [Tango icon theme @ FreeDesktop](https://tango.freedesktop.org/Tango_Icon_Library).
  - [Tela icon theme @ GitHub](https://github.com/vinceliuice/tela-icon-theme).
  - [Tela Circle Icon Theme @ GitHub](https://github.com/vinceliuice/Tela-circle-icon-theme).
  - [Vimix icon theme @ GitHub](https://github.com/vinceliuice/vimix-icon-theme).
  - [WhiteSur icon theme @ GitHub](https://github.com/vinceliuice/WhiteSur-icon-theme).
  - [Xfce icon theme homepage](https://www.xfce.org/)
    ([Rodent icon theme @ Xfce](https://docs.xfce.org/xfce/xfce4-icon-theme/start)).

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
      package = pkgs.faba-icon-theme;
      dark = "Faba-dark";
      light = "Faba-light";
    };
    flat-remix-black = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Black-Dark";
      light = "Flat-Remix-Black-Light";
    };
    flat-remix-black-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Black-Dark";
      light = "Flat-Remix-Black-Light-darkPanel";
    };
    flat-remix-blue = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Blue-Dark";
      light = "Flat-Remix-Blue-Light";
    };
    flat-remix-blue-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Blue-Dark";
      light = "Flat-Remix-Blue-Light-darkPanel";
    };
    flat-remix-brown = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Brown-Dark";
      light = "Flat-Remix-Brown-Light";
    };
    flat-remix-brown-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Brown-Dark";
      light = "Flat-Remix-Brown-Light-darkPanel";
    };
    flat-remix-cyan = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Cyan-Dark";
      light = "Flat-Remix-Cyan-Light";
    };
    flat-remix-cyan-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Cyan-Dark";
      light = "Flat-Remix-Cyan-Light-darkPanel";
    };
    flat-remix-green = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Green-Dark";
      light = "Flat-Remix-Green-Light";
    };
    flat-remix-green-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Green-Dark";
      light = "Flat-Remix-Green-Light-darkPanel";
    };
    flat-remix-grey = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Grey-Dark";
      light = "Flat-Remix-Grey-Light";
    };
    flat-remix-grey-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Grey-Dark";
      light = "Flat-Remix-Grey-Light-darkPanel";
    };
    flat-remix-magenta = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Magenta-Dark";
      light = "Flat-Remix-Magenta-Light";
    };
    flat-remix-magenta-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Magenta-Dark";
      light = "Flat-Remix-Magenta-Light-darkPanel";
    };
    flat-remix-orange = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Orange-Dark";
      light = "Flat-Remix-Orange-Light";
    };
    flat-remix-orange-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Orange-Dark";
      light = "Flat-Remix-Orange-Light-darkPanel";
    };
    flat-remix-red = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Red-Dark";
      light = "Flat-Remix-Red-Light";
    };
    flat-remix-red-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Red-Dark";
      light = "Flat-Remix-Red-Light-darkPanel";
    };
    flat-remix-teal = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Teal-Dark";
      light = "Flat-Remix-Teal-Light";
    };
    flat-remix-teal-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Teal-Dark";
      light = "Flat-Remix-Teal-Light-darkPanel";
    };
    flat-remix-violet = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Violet-Dark";
      light = "Flat-Remix-Violet-Light";
    };
    flat-remix-violet-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Violet-Dark";
      light = "Flat-Remix-Violet-Light-darkPanel";
    };
    flat-remix-yellow = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Yellow-Dark";
      light = "Flat-Remix-Yellow-Light";
    };
    flat-remix-yellow-darkpanel = {
      package = pkgs.flat-remix-icon-theme;
      dark = "Flat-Remix-Yellow-Dark";
      light = "Flat-Remix-Yellow-Light-darkPanel";
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
    nordzy = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-dark";
      light = "Nordzy";
    };
    nordzy-cyan = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-cyan-dark";
      light = "Nordzy-cyan";
    };
    nordzy-green = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-green-dark";
      light = "Nordzy-green";
    };
    nordzy-orange = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-orange-dark";
      light = "Nordzy-orange";
    };
    nordzy-pink = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-pink-dark";
      light = "Nordzy-pink";
    };
    nordzy-purple = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-purple-dark";
      light = "Nordzy-purple";
    };
    nordzy-red = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-red-dark";
      light = "Nordzy-red";
    };
    nordzy-turquoise = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-turquoise-dark";
      light = "Nordzy-turquoise";
    };
    nordzy-yellow = {
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy-yellow-dark";
      light = "Nordzy-yellow";
    };
    papirus = {
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    papirus-maia = {
      package = pkgs.papirus-maia-icon-theme;
      dark = "Papirus-Dark-Maia";
      light = "Papirus-Light-Maia";
    };
    papirus-maia-adapta = {
      package = pkgs.papirus-maia-icon-theme;
      dark = "Papirus-Adapta-Nokto-Maia";
      light = "Papirus-Adapta-Maia";
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
    tela = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-dark";
      light = "Tela-light";
    };
    tela-black = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-black-dark";
      light = "Tela-black-light";
    };
    tela-blue = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-blue-dark";
      light = "Tela-blue-light";
    };
    tela-brown = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-brown-dark";
      light = "Tela-brown-light";
    };
    tela-dracula = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-dracula-dark";
      light = "Tela-dracula-light";
    };
    tela-green = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-green-dark";
      light = "Tela-green-light";
    };
    tela-grey = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-grey-dark";
      light = "Tela-grey-light";
    };
    tela-manjaro = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-manjaro-dark";
      light = "Tela-manjaro-light";
    };
    tela-nord = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-nord-dark";
      light = "Tela-nord-light";
    };
    tela-orange = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-orange-dark";
      light = "Tela-orange-light";
    };
    tela-pink = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-pink-dark";
      light = "Tela-pink-light";
    };
    tela-purple = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-purple-dark";
      light = "Tela-purple-light";
    };
    tela-red = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-red-dark";
      light = "Tela-red-light";
    };
    tela-ubuntu = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-ubuntu-dark";
      light = "Tela-ubuntu-light";
    };
    tela-yellow = {
      package = pkgs.tela-icon-theme;
      dark = "Tela-yellow-dark";
      light = "Tela-yellow-light";
    };
    tela-circle = {
      package = pkgs.tela-circle-icon-theme;
      dark = "Tela-circle-dark";
      light = "Tela-circle-light";
    };
    vimix = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-dark";
      light = "Vimix";
    };
    vimix-amethyst = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-amethyst-dark";
      light = "Vimix-amethyst";
    };
    vimix-beryl = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-beryl-dark";
      light = "Vimix-beryl";
    };
    vimix-black = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-black-dark";
      light = "Vimix-black";
    };
    vimix-doder = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-doder-dark";
      light = "Vimix-doder";
    };
    vimix-jade = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-jade-dark";
      light = "Vimix-jade";
    };
    vimix-ruby = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-ruby-dark";
      light = "Vimix-ruby";
    };
    vimix-white = {
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-white-dark";
      light = "Vimix-white";
    };
    whitesur = {
      package = pkgs.whitesur-icon-theme;
      dark = "WhiteSur-dark";
      light = "WhiteSur-light";
    };
    xfce4 = {
      package = pkgs.xfce4-icon-theme;
      dark = "Rodent";
      light = "Rodent";
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
