/**
  # Starship

  Starship is a minimal, blazing-fast,
  and infinitely customizable prompt for any shell!

  ## 🛠️ Tech Stack

  - [Starship homepage](https://starship.rs/)
    ([Starship @ GitHub](https://github.com/starship/starship)).
  - [jj-starship @ GitHub](https://github.com/dmmulroy/jj-starship).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.starship @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable).
  - [programs.starship @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.starship.).

  ### 🎨 Stylix

  - [starship @ Stylix](https://nix-community.github.io/stylix/options/modules/starship.html).

  ## 🙇 Acknowledgements

  - [Ep 47: Not a Bar or a Camp @ Linux Matters](https://linuxmatters.sh/47/).
  - [A delightful Catppuccin theme for Starship @ Martin Wimpress' GitHub Gist](https://gist.github.com/flexiondotorg/d823f23a2c0b2f1f4fd181e521b1618f).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.starship;
in
{
  options = {
    biapy.programs.starship.enable = mkEnableOption "starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = mkDefault true;

      presets = mkDefault [
        "nerd-font-symbols"
        "no-empty-icons"
      ];

      settings = mkDefault {
        directory = mkOptionDefault {
          format = "[ $path]($style)[$read_only]($read_only_style)";
          home_symbol = "";
          read_only = " 󰌾";
          read_only_style = "bold fg:crust bg:mauve";
          style = "fg:base bg:mauve";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            Apps = "󰵆 ";
            Audio = " ";
            Crypt = "󰌾 ";
            Desktop = " ";
            Developer = "󰲋 ";
            Development = "󰲋 ";
            Documents = "󰈙 ";
            Downloads = " ";
            Dropbox = " ";
            Games = "󰊴 ";
            Keybase = "󰯄 ";
            Music = "󰝚 ";
            Pictures = " ";
            Public = " ";
            Quickemu = " ";
            Studio = "󰡇 ";
            Vaults = "󰌿 ";
            Videos = " ";
            Volatile = "󱪃 ";
            Websites = "󰖟 ";
            Zero = "󰎡 ";
            nix-config = "󱄅 ";
          };
        };
      };
    };
  };
}
