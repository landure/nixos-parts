/**
  # Addy Osmani Agent Skills

  Install selected skills from Addy Osmani's production-grade engineering
  skills for AI coding agents, covering the full software development
  lifecycle from spec to ship.

  ## 🛠️ Tech Stack

  - [Addy Osmani Agent Skills @ GitHub](https://github.com/addyosmani/agent-skills).
  - [Addy Osmani Agent Skills @ skills.addy.ie](https://skills.addy.ie).
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

  cfg = config.biapy.skills.addyosmani-agent-skills;

  package = pkgs.biapy-parts.addyosmani-agent-skills;

  skills = [
    "accessibility-engineering"
    "api-and-interface-design"
    "browser-testing-with-devtools"
    "ci-cd-and-automation"
    "code-review-and-quality"
    "code-simplification"
    "constraint-driven-development"
    "context-engineering"
    "debugging-and-error-recovery"
    "deprecation-and-migration"
    "documentation-and-adrs"
    "doubt-driven-development"
    "frontend-ui-engineering"
    "git-workflow-and-versioning"
    "idea-refine"
    "incremental-implementation"
    "interview-me"
    "observability-and-instrumentation"
    "performance-optimization"
    "planning-and-task-breakdown"
    "security-and-hardening"
    "shipping-and-launch"
    "source-driven-development"
    "spec-driven-development"
    "test-driven-development"
    "using-agent-skills"
  ];
in
{
  options.biapy.skills.addyosmani-agent-skills = {
    enable = mkEnableOption "Addy Osmani agent skills";

    skills = mkOption {
      type = listOf (enum skills);
      default = [
        "code-review-and-quality"
        "debugging-and-error-recovery"
        "documentation-and-adrs"
        "planning-and-task-breakdown"
        "spec-driven-development"
        "test-driven-development"
      ];
      description = "The Addy Osmani agent skills to install.";
      example = [
        "accessibility-engineering"
        "performance-optimization"
        "shipping-and-launch"
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
