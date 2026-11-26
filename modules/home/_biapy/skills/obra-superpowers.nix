/**
  # Superpowers

  Superpowers is a complete software development methodology
  for your coding agents, built on top of a set of composable skills
  and some initial instructions that make sure your agent uses them.

  ## 🛠️ Tech Stack

  - [Superpowers @ GitHub](https://github.com/obra/superpowers).
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

  cfg = config.biapy.skills.obra-superpowers;

  package = pkgs.biapy-parts.obra-superpowers;

  skills = [
    "brainstorming"
    "diagnosing-superpowers"
    "dispatching-parallel-agents"
    "executing-plans"
    "finishing-a-development-branch"
    "receiving-code-review"
    "requesting-code-review"
    "subagent-driven-development"
    "systematic-debugging"
    "test-driven-development"
    "using-git-worktrees"
    "using-superpowers"
    "verification-before-completion"
    "writing-plans"
    "writing-skills"
  ];
in
{
  options.biapy.skills.obra-superpowers = {
    enable = mkEnableOption "Superpowers agent skills";

    skills = mkOption {
      type = listOf (enum skills);
      default = [
        "using-git-worktrees"
        "writing-plans"
        "writing-skills"
      ];
      description = "The Superpowers agent skills to install.";
      example = [
        "brainstorming"
        "diagnosing-superpowers"
        "dispatching-parallel-agents"
        "executing-plans"
        "finishing-a-development-branch"
        "receiving-code-review"
        "requesting-code-review"
        "subagent-driven-development"
        "systematic-debugging"
        "test-driven-development"
        "using-git-worktrees"
        "using-superpowers"
        "verification-before-completion"
        "writing-plans"
        "writing-skills"
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
