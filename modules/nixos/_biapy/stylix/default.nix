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
  - [tinted-schemes @ GitHub](https://github.com/tinted-theming/schemes).
  - [tinty @ GitHub](https://github.com/tinted-theming/tinty).

  ## 📝 Documentation

  ### 🎨 Stylix

  - [stylix.base16Scheme](https://nix-community.github.io/stylix/options/platforms/nixos.html#stylixbase16scheme)
  - [stylix.homeManagerIntegration](https://nix-community.github.io/stylix/options/platforms/nixos.html#stylixhomemanagerintegrationautoimport).
  - [stylix.overlays](https://nix-community.github.io/stylix/options/platforms/nixos.html#stylixoverlaysenable).
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
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.biapy.stylix;
in
{
  options.biapy.stylix = {
    enable = mkEnableOption "stylix theming";

    console-theme = mkOption {
      type = str;
      description = "base16 scheme name";
      default = "catppuccin-mocha";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tinty ];

    biapy.stylix = {
      fonts.enable = mkDefault true;
      icons.enable = mkDefault true;
    };

    stylix = {
      enable = mkDefault true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.console-theme}.yaml";
    };
  };
}
