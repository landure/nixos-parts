/**
  # Kakoune editor

  ## 🛠️ Tech Stack

  - [Kakoune homepage](https://kakoune.org/)
    ([Kakoune @ GitHub](https://github.com/mawww/kakoune)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.kakoune @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kakoune.enable).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.kakoune;
in
{
  options = {
    biapy.programs.kakoune.enable = mkEnableOption "kakoune";
  };

  config = mkIf cfg.enable {
    programs.kakoune = {
      enable = mkDefault true;
      defaultEditor = mkDefault (config.biapy.console.text-editors.default == "kakoune");
    };
  };
}
