/**
  # Guard Skills

  Guard skills for coding agents: second-pass quality gates that catch the
  systematic failure modes of AI-generated code, tests, and docs.

  ## 🛠️ Tech Stack

  - [guard-skills @ GitHub](https://github.com/amElnagdy/guard-skills).
  - [guard-skills @ skills.sh](https://skills.sh/amElnagdy/guard-skills).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum listOf;

  cfg = config.biapy.skills.guard-skills;

  package = pkgs.biapy-parts.guard-skills;

  skills = [
    "clean-code-guard"
    "docs-guard"
    "test-guard"
    "woo-guard"
    "wp-guard"
  ];
in
{
  options.biapy.skills.guard-skills = {
    enable = mkEnableOption "guard skills";

    skills = mkOption {
      type = listOf (enum skills);
      default = [
        "clean-code-guard"
        "docs-guard"
        "test-guard"
      ];
      description = "The guard skills to install.";
      example = [
        "clean-code-guard"
        "docs-guard"
        "test-guard"
        "wp-guard"
        "woo-guard"
      ];
    };
  };

  config = mkIf cfg.enable {
    biapy.ai.skills.skills = builtins.listToAttrs (
      map (name: {
        inherit name;
        value = "${package}/skills/${name}";
      }) cfg.skills
    );
  };
}
