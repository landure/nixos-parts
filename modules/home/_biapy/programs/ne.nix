/**
  # ne editor

  ## 🛠️ Tech Stack

  - [ne @ GitHub](https://github.com/vigna/ne/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.ne @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ne.enable).
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

  cfg = config.biapy.programs.ne;
in
{
  options = {
    biapy.programs.ne = {
      enable = mkEnableOption "ne editor";

      defaultEditor = mkOption {
        type = types.bool;
        default = config.biapy.console.text-editors.default == "ne";
        description = ''
          Whether to configure {command}`ne` as the default
          editor using the {env}`EDITOR` and {env}`VISUAL`
          environment variables.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = mkOptionDefault "ne";
      VISUAL = mkOptionDefault "ne";
    };

    programs.ne.enable = mkDefault true;
  };
}
