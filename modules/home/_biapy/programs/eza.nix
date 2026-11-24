/**
  # eza

  eza is a modern alternative to ls.

  ## 🛠️ Tech Stack

  - [eza homepage](https://eza.rocks/)
    ([eza @ GitHub](https://github.com/eza-community/eza)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.eza](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable).

  ## 🙇 Acknowledgements

  - [default -t to modified -r to be backward compatible with ls @ eza's GitHub](https://github.com/eza-community/eza/issues/980).
  - [Tip 5: Replacing ls with exa @ David McKay's dev.to](https://dev.to/rawkode/tip-5-replacing-ls-with-exa-3o5n).
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

  cfg = config.biapy.programs.eza;
in
{
  options.biapy.programs.eza.enable = mkEnableOption "eza";

  config = mkIf cfg.enable {
    programs.eza = {
      enable = mkDefault true;
      colors = mkDefault "auto";
      git = mkDefault true;
      icons = mkDefault "auto";
      extraOptions = mkDefault [
        "--group-directories-first"
        "--header"
      ];
    };

    home = {
      shellAliases = {
        ltd = mkDefault "ls --tree --only-dirs --level=2 --ignore-glob='cache|log|logs|node_modules|vendor'";
        lt3d = mkDefault "ls --tree --only-dirs --level=3 --ignore-glob='cache|log|logs|node_modules|vendor'";
        lt4d = mkDefault "ls --tree --only-dirs --level=4 --ignore-glob='cache|log|logs|node_modules|vendor'";
        lt5d = mkDefault "ls --tree --only-dirs --level=5 --ignore-glob='cache|log|logs|node_modules|vendor'";
      };
      packages = [
        # Use the same eza as the one configured for the `programs.eza` module.
        (pkgs.biapy-parts.lazes.overrideAttrs (old: {
          runtimeInputs = [
            config.programs.eza.package
            config.biapy.programs.gum.package
          ];
        }))
      ];
    };
  };
}
