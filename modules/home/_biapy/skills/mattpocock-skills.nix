/**
  # Matt Pocock skills

  Install selected skills from Matt Pocock's practical skill system.

  ## 🛠️ Tech Stack

  - [Matt Pocock Skills @ GitHub](https://github.com/mattpocock/skills).
  - [Matt Pocock Skills @ AI Hero](https://www.aihero.dev/skills).
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
  inherit (lib.types) enum listOf;

  cfg = config.biapy.skills.mattpocock-skills;

  package = pkgs.biapy-parts.mattpocock-skills;

  skills = {
    ask-matt = "engineering/ask-matt";
    code-review = "engineering/code-review";
    codebase-design = "engineering/codebase-design";
    diagnosing-bugs = "engineering/diagnosing-bugs";
    domain-modeling = "engineering/domain-modeling";
    grill-with-docs = "engineering/grill-with-docs";
    implement = "engineering/implement";
    implement-spec = "engineering/implement-spec";
    improve-codebase-architecture = "engineering/improve-codebase-architecture";
    pr = "engineering/pr";
    prototype = "engineering/prototype";
    research = "engineering/research";
    retro = "engineering/retro";
    setup-matt-pocock-skills = "engineering/setup-matt-pocock-skills";
    tdd = "engineering/tdd";
    to-spec = "engineering/to-spec";
    to-tickets = "engineering/to-tickets";
    triage = "engineering/triage";
    wayfinder = "engineering/wayfinder";
    wizard = "engineering/wizard";
    chief-of-staff = "in-progress/chief-of-staff";
    claude-handoff = "in-progress/claude-handoff";
    loop-me = "in-progress/loop-me";
    setup-ts-deep-modules = "in-progress/setup-ts-deep-modules";
    writing-beats = "in-progress/writing-beats";
    writing-fragments = "in-progress/writing-fragments";
    writing-shape = "in-progress/writing-shape";
    git-guardrails-claude-code = "misc/git-guardrails-claude-code";
    migrate-to-shoehorn = "misc/migrate-to-shoehorn";
    scaffold-exercises = "misc/scaffold-exercises";
    setup-pre-commit = "misc/setup-pre-commit";
    grill-me = "productivity/grill-me";
    grilling = "productivity/grilling";
    handoff = "productivity/handoff";
    teach = "productivity/teach";
    to-questionnaire = "productivity/to-questionnaire";
    wait-what = "productivity/wait-what";
    writing-for-agents = "productivity/writing-for-agents";
  };
in
{
  options.biapy.skills.mattpocock-skills = {
    enable = mkEnableOption "Matt Pocock agent skills";

    skills = mkOption {
      type = listOf (enum (builtins.attrNames skills));
      default = [
        # "ask-matt"
        "code-review"
        "codebase-design"
        "diagnosing-bugs"
        "domain-modeling"
        "grill-with-docs"
        "implement"
        "implement-spec"
        "improve-codebase-architecture"
        "pr"
        "prototype"
        "research"
        "retro"
        "tdd"
        "to-spec"
        "to-tickets"
        "triage"
        "wayfinder"
        "wizard"
        # "chief-of-staff"
        # "claude-handoff"
        # "loop-me"
        # "setup-ts-deep-modules"
        # "writing-beats"
        # "writing-fragments"
        # "writing-shape"
        # "git-guardrails-claude-code"
        # "migrate-to-shoehorn"
        # "scaffold-exercises"
        # "setup-pre-commit"
        "grill-me"
        "grilling"
        "handoff"
        "teach"
        "to-questionnaire"
        "wait-what"
        "writing-for-agents"
      ];
      description = "The Matt Pocock skills to install.";
      example = [
        "grill-with-docs"
        "teach"
      ];
    };
  };

  config = mkIf cfg.enable {
    biapy.programs.gh.enable = mkDefault true;

    biapy.ai.skills.skills = builtins.listToAttrs (
      map (name: {
        inherit name;
        value = "${package}/skills/${skills.${name}}";
      }) cfg.skills
    );
  };
}
