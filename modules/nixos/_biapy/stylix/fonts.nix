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

  ## 📝 Documentation

  ### 🎨 Stylix

  - [stylix.fonts](https://nix-community.github.io/stylix/options/platforms/nixos.html#stylixfontsemojiname).

  ## 🙇 Acknowledgements

  - [Fonts @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Fonts).
  - [Theming @ vlaci's nix knowledge base](https://vlaci.github.io/nix.org/posts/theming).
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

  cfg = config.biapy.stylix.fonts;
in
{
  options.biapy.stylix.fonts = {
    enable = mkEnableOption "stylix fonts";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = mkDefault true;

      fonts = {
        serif = mkDefault {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = mkDefault {
          package = pkgs.atkinson-hyperlegible-next;
          name = "Atkinson Hyperlegible Next";
        };

        monospace = mkDefault {
          package = pkgs.nerd-fonts.fira-mono;
          name = "FiraMono Nerd Font";
        };

        emoji = mkDefault {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
