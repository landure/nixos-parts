/**
  # Cheatsheets

  This module installs:

  - Arsenal
  - cheat.sh
  - IntelliShell
  - navi
  - tldr

  ## 🛠️ Tech Stack

  - [Arsenal @ GitHub](https://github.com/Orange-Cyberdefense/arsenal).
  - [cheat.sh homepage](https://cht.sh/)
    ([cheat.sh @ GitHub](https://github.com/chubin/cheat.sh)).
  - [IntelliShell homepage](https://lasantosr.github.io/intelli-shell/)
    ([IntelliShell @ GitHub](https://github.com/lasantosr/intelli-shell)).
  - [navi @ GitHub](https://github.com/denisidoro/navi).
  - [tldr pages homepage](https://tldr.sh/).
  - [Tealdeer homepage](https://tealdeer-rs.github.io/tealdeer/)
    ([Tealdeer @ GitHub](https://github.com/tealdeer-rs/tealdeer)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.intelli-shell @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.intelli-shell.enable).
  - [programs.navi @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.navi.enable).
  - [programs.tealdeer @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tealdeer.enable).

  ## 🙇 Acknowledgements

  - [Use CLI like a modern tech bro @ tsukie](https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) bool;

  cfg = config.biapy.console.cheatsheets;

in
{
  options = {
    biapy.console.cheatsheets.enable = mkEnableOption "cheatsheets";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      help = "${getExe config.programs.tealdeer.package}";
    };

    programs = {
      intelli-shell = {
        enable = mkDefault true;
        settings = {
          check_updates = false;
          # data_dir = "/home/myuser/my/custom/datadir";
          # logs = {
          #   enabled = false;
          # };
          # theme = {
          #   accent = "yellow";
          #   comment = "italic green";
          #   error = "dark red";
          #   highlight = "darkgrey";
          #   highlight_accent = "yellow";
          #   highlight_comment = "italic green";
          #   highlight_primary = "default";
          #   highlight_secondary = "default";
          #   highlight_symbol = "» ";
          #   primary = "default";
          #   secondary = "dim";
          # };
        };

        # Settings for customizing the keybinding to integrate your shell with intelli-shell.
        # See: https://lasantosr.github.io/intelli-shell/guide/installation.html#customizing-shell-integration.
        # shellHotKeys = {
        #   bookmark_hotkey = "\\\\C-b";
        #   fix_hotkey = "\\\\C-p";
        #   search_hotkey = "\\\\C-t";
        #   skip_esc_bind = "\\\\C-q";
        #   variable_hotkey = "\\\\C-a";
        # };
      };

      navi.enable = mkDefault true;

      tealdeer = {
        enable = mkDefault true;
        settings = {
          # Whether to enable auto-update.
          updates.auto_update = mkDefault true;
        };
      };
    };

    home.packages = with pkgs; [
      arsenal
      # command-line interface for the Cheat.sh service
      cht-sh
    ];
  };
}
