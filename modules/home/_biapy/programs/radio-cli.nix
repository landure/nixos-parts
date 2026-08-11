/**
  # radio-cli

  A simple radio CLI written in rust.

  ## 🛠️ Tech Stack

  - [radio-cli @ GitHub](https://github.com/margual56/radio-cli).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.radio-cli @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.radio-cli.enable).

  ## 🙇 Acknowledgements

  - [Scripts I wrote that I use all the time @ Evan Hahn](https://evanhahn.com/scripts-i-wrote-that-i-use-all-the-time/).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.radio-cli;

in
{
  options = {
    biapy.programs.radio-cli.enable = mkEnableOption "radio-cli";
  };

  config = mkIf cfg.enable {
    programs.radio-cli = {
      enable = mkDefault true;
      settings = {
        config_version = "2.3.0";
        country = mkDefault "FR";
        data = mkDefault builtins.attrValues (
          builtins.mapAttrs
            (station: url: {
              inherit station;
              inherit url;
            })
            {
              "Lofi Girl 🎶" = "https://www.youtube.com/live/jfKfPfyJRdk?si=WDl-XdfuhxBfe6XN";
              "Nostalgie 🎶🇫🇷" = "https://streaming.nrjaudio.fm/oug7girb92oc";
              "France Inter 🇫🇷" = "https://icecast.radiofrance.fr/franceinter-midfi.mp3";
              "France Info 🇫🇷" = "https://icecast.radiofrance.fr/franceinfo-midfi.mp3";
              "France Bleu Breizh Izel 🇫🇷" = "https://icecast.radiofrance.fr/fbbreizizel-midfi.mp3";
              "Latina.fr Salsa 🎶🇫🇷" = "https://latinasalsa.ice.infomaniak.ch/latinasalsa.mp3";
              "Hunter.fm Lo-Fi 🎶 (High) 🇧🇷" = "https://live.hunter.fm/lofi_high";
              "Hunter.fm Lo-Fi 🎶 (Low) 🇧🇷" = "https://live.hunter.fm/lofi_high";
              "Hunter.fm Rock 🎶 (High) 🇧🇷" = "https://live.hunter.fm/rock_high";
              "Hunter.fm Rock 🎶 (Low) 🇧🇷" = "https://live.hunter.fm/rock_low";
              "HBR1.com Dream Factory 🎶" = "http://radio.hbr1.com/stream/ambient.ogg";
              "HBR1.com I.D.M. Tranceponder 🎶" = "http://radio.hbr1.com/stream/trance.ogg";
              "HBR1.com Tronic Lounge 🎶" = "http://radio.hbr1.com/stream/tronic.ogg";
            }
        );
        max_lines = mkDefault 7;
      };
    };
  };
}
