/**
  # Helix editor

  ## 🛠️ Tech Stack

  - [Helix homepage](https://helix-editor.com/)
    ([Helix @ GitHub](https://github.com/helix-editor/helix)).

  ## 📝 Documentation

    ### 🏠 Home Manager

  - [programs.helix @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.enable).

  ### 🎨 Stylix

  - [Helix](https://nix-community.github.io/stylix/options/modules/helix.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.helix;
in
{
  options = {
    biapy.programs.helix.enable = mkEnableOption "helix";
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = mkDefault true;
      defaultEditor = mkDefault (config.biapy.console.text-editors.default == "helix");
    };
  };
}
