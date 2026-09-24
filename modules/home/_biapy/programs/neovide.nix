/**
  # Neovide

  Neovide is a simple, no-nonsense, cross-platform graphical user interface
  for Neovim (an aggressively refactored and updated Vim editor).

  ## 🛠️ Tech Stack

  - [Neovide homepage](https://neovide.dev/).
  - [Neovide @ GitHub](https://github.com/microsoft/edit).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.neovide @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovide.enable).
  - [programs.neovide @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.neovide.).

  ### 🎨 Stylix

  - [Neovim, Neovide, NixVim, nvf, and Vim](https://nix-community.github.io/stylix/options/modules/neovim.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.neovide;
in
{
  options.biapy.programs.neovide.enable = mkEnableOption "neovide editor";

  config = mkIf cfg.enable {
    biapy.programs.neovim.enable = mkDefault true;

    programs.neovide = {
      enable = mkDefault true;
      settings = {
        fork = mkOptionDefault false;
        frame = mkOptionDefault "full";
        idle = mkOptionDefault true;
        maximized = mkOptionDefault false;
        neovim-bin = mkOptionDefault (getExe config.programs.neovim.package);
        no-multigrid = mkOptionDefault false;
        srgb = mkOptionDefault false;
        tabs = mkOptionDefault true;
        theme = mkOptionDefault "auto";
        title-hidden = mkOptionDefault true;
        vsync = mkOptionDefault true;
        wsl = mkOptionDefault false;

        # font = {
        #   normal = [ ];
        #   size = 14.0;
        # };
      };
    };
  };
}
