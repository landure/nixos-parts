/**
  # tray-tui

  A system tray implementation for terminal user interfaces (TUI)
  using ratatui and system-tray.

  ## 🛠️ Tech Stack

  - [tray-tui @ GitHub](https://github.com/Levizor/tray-tui).

  ## 🙇 Acknowledgements

  ### 🏠 Home Manager

  - [programs.tray-tui @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/tray-tui.html).
  - [programs.tray-tui @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.tray-tui.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.tray-tui;
in
{
  options.biapy.programs.tray-tui.enable = mkEnableOption "tray-tui";

  config = mkIf cfg.enable {
    programs.tray-tui = {
      enable = mkDefault true;

      settings = {
        sorting = mkDefault true;
        mouse = mkDefault true;
        columns = mkDefault 3;
        key_map = {
          down = mkDefault "focus_down";
          left = mkDefault "focus_left";
          right = mkDefault "focus_right";
          up = mkDefault "focus_up";
        };
      };
    };
  };
}
