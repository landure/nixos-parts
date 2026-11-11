{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;

  cfg = config.biapy.programs.gum;

in
{
  options.biapy.programs.gum = {
    enable = mkEnableOption "gum";

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install the gum agent skill.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gum
    ];

    biapy.ai.skills.skills = mkIf cfg.withSkill {
      gum = mkDefault "";
    };
  };
}
