/**
  # Helix editor

  ## 🛠️ Tech Stack

  - [Helix homepage](https://helix-editor.com/)
    ([Helix @ GitHub](https://github.com/helix-editor/helix)).

  ## 📝 Documentation

    ### 🏠 Home Manager

  - [programs.helix @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/helix.html).
  - [programs.helix @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.helix.).

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
      settings = {
        editor = {
          middle-click-paste = mkDefault true;
          # yank to system clipboard by default (with wl-copy)
          default-yank-register = mkDefault "+";
          line-number = mkDefault "relative";
          lsp = {
            display-messages = mkDefault true;
          };
          cursor-shape = {
            insert = mkDefault "bar";
            normal = mkDefault "block";
            select = mkDefault "underline";
          };
        };
        keys = {
          normal = {
            esc = mkDefault [
              "collapse_selection"
              "keep_primary_selection"
            ];
            space = {
              q = mkDefault ":q";
              space = mkDefault "file_picker";
              w = mkDefault ":w";
            };
          };
        };
      };
    };
  };
}
