/**
  ## Wofi

  Wofi is a launcher/menu program for wlroots based wayland compositors
  such as sway.

  ## 🛠️ Tech Stack

  - [wofi @ sourcehut](https://hg.sr.ht/~scoopta/wofi)

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.wofi @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/wofi.html).
  - [programs.wofi @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.wofi.).

  ### 🎨 Stylix

  - [Wofi @ Stylix](https://nix-community.github.io/stylix/options/modules/wofi.html).

  ## 🙇 Acknowledgements

  - [Sway on NixOS via Home Manager @ Joseph LaFreniere](https://lafreniere.xyz/docs/nix-home-manager-sway.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.wofi;
in
{
  options.biapy.programs.wofi.enable = mkEnableOption "Wofi";

  config = mkIf cfg.enable {
    programs.wofi = {
      enable = mkDefault true;
      settings = {
        allow_markup = mkDefault true;
      };
      #     style = ''
      #       * {
      #           font-family: monospace;
      #       }
      #
      #       window {
      #           background-color: #7c818c;
      #       }
      #     '';
    };
  };
}
