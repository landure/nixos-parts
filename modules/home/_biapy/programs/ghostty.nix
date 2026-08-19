/**
  # Ghostty

  ## 🛠️ Tech Stack

  - [Ghostty homepage](https://ghostty.org/)
    ([Ghostty @ GitHub](https://github.com/ghostty-org/ghostty)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.ghostty @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ghostty.enable).
  - [programs.ghostty @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.ghostty.).

  ### 🎨 Stylix

  - [Ghostty @ Stylix](https://nix-community.github.io/stylix/options/modules/ghostty.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.ghostty;
in
{
  options = {
    biapy.programs.ghostty.enable = mkEnableOption "ghostty";
  };

  config = mkIf cfg.enable {

    programs.ghostty = {
      enable = mkDefault true;
      # clear default keybinds.
      # clearDefaultKeybinds = false;

      # install Ghostty configuration syntax for bat.
      installBatSyntax = mkDefault config.programs.bat.enable;
      # installation of Ghostty configuration syntax for Vim.
      installVimSyntax = mkDefault config.programs.vim.enable;

      # Configuration written to $XDG_CONFIG_HOME/ghostty/config.
      # settings = '''';
    };
  };
}
