/**
  # fzf

  fzf fuzzy finder, with custom setup & aliases

  ## 🛠️ Tech Stack

  - [fzf homepage](https://junegunn.github.io/fzf/)
    ([fzf @ GitHub](https://github.com/junegunn/fzf)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [programs.fzf @ NixOS reference](https://search.nixos.org/options?query=programs.fzf.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.fzf;
in
{
  options = {
    biapy.programs.fzf.enable = mkEnableOption "fzf fuzzy finder";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      # Shell history and completion using fzf in OS.
      keybindings = mkDefault true;
      fuzzyCompletion = mkDefault true;
    };
  };
}
