/**
  # Microsoft edit

  ## 🛠️ Tech Stack

  - [Microsoft edit @ GitHub](https://github.com/microsoft/edit).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;

  cfg = config.biapy.programs.msedit;
in
{
  options = {
    biapy.programs.msedit = {
      enable = mkEnableOption "msedit editor";

      defaultEditor = mkOption {
        type = types.bool;
        default = config.biapy.console.text-editors.default == "msedit";
        description = ''
          Whether to configure {command}`edit` as the default
          editor using the {env}`EDITOR` and {env}`VISUAL`
          environment variables.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = mkOptionDefault "edit";
      VISUAL = mkOptionDefault "edit";
    };

    home.packages = with pkgs; [ msedit ];
  };
}
