/**
  # Mozilla Firefox or derivatives

  Mozilla Firefox, or simply Firefox, is a free and open-source web browser
  developed by the Mozilla Foundation.

  ## 🛠️ Tech Stack

  - [Mozilla Firefox homepage](https://www.firefox.com/).
  - [LibreWolf homepage](https://librewolf.net/).
  - [Floorp homepage](https://floorp.app/en-US).
  - [Zen Browser homepage](https://zen-browser.app/).

  ### 🐚 Command-line

  - [browsh homepage](https://www.brow.sh/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.firefox @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/firefox.html).
  - [programs.firefox @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.firefox.).
  - [programs.floorp @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/floorp.html).
  - [programs.floorp @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.floorp.).

  ### 🎨 Stylix

  - [Firefox and its derivatives @ Stylix](https://nix-community.github.io/stylix/options/modules/firefox.html).

  ## 🙇 Acknowledgements

  - [Firefox @ NixOS Wiki](https://nixos.wiki/wiki/Firefoxnixos.wiki/wiki/Firefox).
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

  cfg = config.biapy.programs.firefox;
in
{
  options.biapy.programs.firefox.enable = mkEnableOption "Mozilla Firefox";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ browsh ];

    # Add to nixos ?
    # services.gnome.gnome-browser-connector.enable = true;

    programs.firefox = {
      enable = mkDefault true;
      configPath = mkDefault "${config.xdg.configHome}/mozilla/firefox";
    };

    stylix.targets.firefox.profileNames = mkDefault [ "work" ];
  };
}
