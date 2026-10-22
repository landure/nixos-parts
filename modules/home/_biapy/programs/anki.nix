/**
  # Anki

  Anki is a flashcard program that helps you spend more time
  on challenging material, and less on what you already know.

  ## 🛠️ Tech Stack

  - [Anki homepage](https://apps.ankiweb.net/).
  - [Anki @ GitHub](https://github.com/ankitects/anki).

  ### 🧩 Addons

  - [adjust-sound-volume @ GitHub](https://github.com/mnogu/adjust-sound-volume).
  - [Card Management @ GitHub](https://github.com/Ajatt-Tools/learn-now-button).
  - [FSRS Helper @ GitHub](https://github.com/open-spaced-repetition/fsrs4anki-helper).
  - [ReColor @ GitHub](https://github.com/AnKing-VIP/AnkiRecolor).
  - [Review Heatmap for Anki @ GitHub](https://github.com/glutanimate/review-heatmap).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.anki @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/anki.html).
  - [programs.anki @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.anki.).

  ### 🎨 Stylix

  - [Anki @ Stylix](https://nix-community.github.io/stylix/options/modules/anki.html).
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

  cfg = config.biapy.programs.anki;
in
{
  options.biapy.programs.anki.enable = mkEnableOption "anki";

  config = mkIf cfg.enable {
    programs.anki = {
      enable = mkDefault true;
      language = config.biapy.user.language.locale or "en_US";
      addons = with pkgs.ankiAddons; [
        adjust-sound-volume
        ajt-card-management
        fsrs4anki-helper
        review-heatmap
      ];
    };
  };
}
