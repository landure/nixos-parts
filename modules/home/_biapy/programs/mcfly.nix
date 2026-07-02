/**
  # McFly

  McFly replaces your default ctrl-r shell history search with an
  intelligent search engine that takes into account your working
  directory and the context of recently executed commands.
  McFly's suggestions are prioritized in real time with a small
  neural network.

  ## 🛠️ Tech Stack

  - [McFly @ GitHub](https://github.com/cantino/mcfly).
  - [McFly fzf integration @ GitHub](https://github.com/bnprks/mcfly-fzf).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.mcfly @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.mcfly.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.mcfly;
in
{
  options = {
    biapy.programs.mcfly.enable = mkEnableOption "McFly shell history";
  };

  config = mkIf cfg.enable {
    # McFly replaces your default ctrl-r shell history search with an
    # intelligent search engine
    programs.mcfly = {
      enable = mkDefault true;

      # enable fuzzy searching. 0 is off; higher numbers weight toward shorter matches.
      # Values in the 2-5 range get good results so far.
      fuzzySearchFactor = mkDefault 3;

      # enable McFly fzf integration.
      fzf.enable = mkDefault true;

      # Interface view to use.  one of "TOP", "BOTTOM"
      interfaceView = mkDefault "TOP";

      # Key scheme to use. one of "emacs", "vim".
      keyScheme = mkDefault "vim";

      # Settings written to ~/.config/mcfly/config.toml.
      # settings = '''';
    };

    home.sessionVariables = {
      # MCFLY_RESULTS = "50";
      # MCFLY_DELETE_WITHOUT_CONFIRM = "true";
      # MCFLY_DISABLE_MENU = "true";
      # MCFLY_RESULTS_SORT = "LAST_RUN";
      MCFLY_PROMPT = "❯";
    };

  };
}
