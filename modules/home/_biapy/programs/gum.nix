/**
  # gum

  `gum` is a tool for glamorous shell scripts.

  ## 🛠️ Tech Stack

  - [gum @ GitHub](https://github.com/charmbracelet/gum)

  ## 🙇 Acknowledgements

  - [Gum CLI skill @ rigerc's skill registry's GitHub](https://github.com/rigerc/skills-registry/tree/main/skills/gum-cli).
*/
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
      gum = mkDefault (
        pkgs.fetchFromGitHub {
          owner = "rigerc";
          repo = "skills-registry";
          rev = "94c4b6c063033eb9a12fdcbd6df50d10f82ec5a0";
          hash = "sha256-y/KFAQ2cdFmwsFT9lLnweajiSpxvYhOJBmXgYO+LP2E=";
        }
        + "/skills/gum-cli"
      );
    };
  };
}
