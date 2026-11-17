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
  - [Fill the blanks - Multiple type:cloze support @ AnkiWeb](https://ankiweb.net/shared/info/1933645497)
    ([Fill the blanks @ GitHub](https://github.com/ssricardo/anki-plugins/tree/master/fill-the-blanks))

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.anki @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/anki.html).
  - [programs.anki @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.anki.).

  ### 🎨 Stylix

  - [Anki @ Stylix](https://nix-community.github.io/stylix/options/modules/anki.html).

  ## 🙇 Acknowledgements

  - [Anki @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Anki).
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
  inherit (lib.types) nullOr path str;

  cfg = config.biapy.programs.anki;
in
{
  options.biapy.programs.anki = {
    enable = mkEnableOption "anki";

    profile = {
      username = mkOption {
        type = nullOr str;
        default = config.biapy.user.identity.email;
        description = "AnkiWeb sync account username.";
      };

      keyFile = mkOption {
        type = nullOr path;
        default =
          if (null != config.sops.defaultSopsFile) then
            config.sops.secrets."biapy/programs/anki/profile/key".path
          else
            null;
        defaultText = ''config.sops.secrets."biapy/programs/anki/profile/key".path'';
        description = "Path to a file containing the AnkiWeb sync key.";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.anki = {
      enable = mkDefault true;
      language = mkDefault (config.biapy.user.language.locale or "en_US");
      profiles.${config.home.username} = {
        default = mkDefault true;
        sync = {
          autoSync = mkDefault true;
          username = mkDefault cfg.profile.username;
          keyFile = mkDefault cfg.profile.keyFile;
        };
      };
      addons = with pkgs.ankiAddons; [
        adjust-sound-volume
        ajt-card-management
        fsrs4anki-helper
        review-heatmap
      ];
    };
  };
}
