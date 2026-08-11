/**
  # micro editor

  ## 🛠️ Tech Stack

  - [micro homepage](https://micro-editor.github.io/)
    ([micro @ GitHub])(https://github.com/zyedidia/micro)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.micro @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.micro.enable).

  ### 🎨 Stylix

  - [Micro](https://nix-community.github.io/stylix/options/modules/micro.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;

  cfg = config.biapy.programs.micro;
in
{
  options = {
    biapy.programs.micro = {
      enable = mkEnableOption "micro editor";

      defaultEditor = mkOption {
        type = types.bool;
        default = config.biapy.console.text-editors.default == "micro";
        description = ''
          Whether to configure {command}`micro` as the default
          editor using the {env}`EDITOR` and {env}`VISUAL`
          environment variables.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = mkOptionDefault "micro";
      VISUAL = mkOptionDefault "micro";
    };

    programs.micro.enable = mkDefault true;
  };
}
