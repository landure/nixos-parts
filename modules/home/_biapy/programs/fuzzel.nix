/**
  # Fuzzel

  ## 🛠️ Tech Stack

  - [Fuzzel @ Codeberg](https://codeberg.org/dnkl/fuzzel).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.fuzzel @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/fuzzel.html).
  - [programs.fuzzel @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.fuzzel.).
  - [wayland.windowManager.sway.config.menu @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/wayland.html#opt-wayland.windowManager.sway.config.menu).

  ### 🎨 Stylix

  - [Fuzzel @ Stylix](https://nix-community.github.io/stylix/options/modules/fuzzel.html).

  ## 🙇 Acknowledgements

  - [Fuzzel: A great dmenu and rofi alternative for Wayland @ Mark Stosberg](https://mark.stosberg.com/fuzzel-a-great-dmenu-and-rofi-altenrative-for-wayland/).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib.strings) concatStringsSep;

  cfg = config.biapy.programs.fuzzel;
in
{
  options.biapy.programs.fuzzel.enable = mkEnableOption "Fuzzel";

  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = mkDefault true;
      settings = {
        main = {
          terminal = mkDefault config.biapy.desktop.terminalEmulators.default;
          layer = mkDefault "overlay";
          fields = mkDefault (
            concatStringsSep "," [
              "name"
              "generic"
              "comment"
              "categories"
              "filename"
              "keywords"
            ]
          );
          prompt = mkDefault "❯   ";
          show-actions = mkDefault true;
          exit-on-keyboard-focus-loss = mkDefault false;
        };
        dmenu = {
          exit-immediately-if-empty = mkDefault true;
        };
      };
    };

    wayland.windowManager.sway.config.menu = "${config.programs.fuzzel.package}/bin/fuzzel";

    # SwayR config
    #lib.concatStringsSep " | " [
    #  "${dmenu-rs}/bin/dmenu_path"
    #  "${fuzzel}/bin/fuzzel --dmenu --prompt='🪟❯' --font='Hack Nerd Font Mono:style=Normal:size=10'"
    #  "${findutils}/bin/xargs swaymsg exec --"
    #];
  };
}
