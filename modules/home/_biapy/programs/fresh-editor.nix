/**
  # fresh editor

  ## 🛠️ Tech Stack

  - [Fresh homepage](https://sinelaw.github.io/fresh/)
    ([Fresh @ GitHub](https://github.com/sinelaw/fresh)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.fresh-editor @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/fresh-editor.html).
  - [programs.fresh-editor @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.fresh-editor.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.fresh-editor;
in
{
  options.biapy.programs.fresh-editor.enable = mkEnableOption "Fresh";

  config = mkIf cfg.enable {
    programs.fresh-editor = {
      enable = mkDefault true;
      defaultEditor = mkDefault (config.biapy.console.text-editors.default == "fresh-editor");
    };
  };
}
