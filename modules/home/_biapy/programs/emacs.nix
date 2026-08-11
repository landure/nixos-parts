/**
  # emacs text editors

  ## 🛠️ Tech Stack

  - [GNU Emacs homepage](https://www.gnu.org/software/emacs/).

  ## 📝 Documentation

  ### ❄️ Nix

  - [lib.options.mkOption @ Noogle](https://noogle.dev/f/lib/options/mkOption).

  ### 🏠 Home Manager

  - [programs.emacs @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.emacs.enable).
  - [services.emacs @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.emacs.enable).

  ### 🎨 Stylix

  - [Emacs](https://nix-community.github.io/stylix/options/modules/emacs.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.emacs;
in
{
  options = {
    biapy.programs.emacs.enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    services.emacs = {
      enable = mkDefault true;
      defaultEditor = mkDefault (config.biapy.console.text-editors.default == "emacs");
    };

    programs.emacs.enable = mkDefault true;
  };
}
