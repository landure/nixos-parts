/**
  # Jeff Allan Claude Skills

  Install selected skills from Jeff Allan's Claude Skills.

  ## 🛠️ Tech Stack

  - [Jeff Allan's Claude Skills homepage](https://jeffallan.github.io/claude-skills).
  - [Jeff Allan's Claude Skills @ GitHub](https://github.com/Jeffallan/claude-skills).
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
  inherit (lib.types) listOf str;

  cfg = config.biapy.skills.jeffallan-claude-skills;

  package = pkgs.biapy-parts.jeffallan-claude-skills;

in
{
  options.biapy.skills.jeffallan-claude-skills = {
    enable = mkEnableOption "Jeff Allan's Claude Skills";

    skills = mkOption {
      type = listOf str;
      default = [
        "api-designer"
        "architecture-designer"
        "cli-developer"
        "code-documenter"
        "code-reviewer"
        "database-optimizer"
        "debugging-wizard"
        "devops-engineer"
        "feature-forge"
        "fine-tuning-expert"
        "fullstack-guardian"
        "graphql-architect"
        "legacy-modernizer"
        "prompt-engineer"
        "secure-code-guardian"
        "security-reviewer"
        "spec-miner"
        "sql-pro"
        "test-master"
        "the-fool"
      ];
      description = "The Jeff Allan's Claude Skills to install.";
      example = [
        "code-reviewer"
        "secure-code-guardian"
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
