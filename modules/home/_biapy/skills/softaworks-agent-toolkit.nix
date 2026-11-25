/**
  # Softaworks Agent Skills

  Install selected skills from Softaworks's agent skills.

  ## 🛠️ Tech Stack

  - [Softaworks Agent Skills @ GitHub](https://github.com/softaworks/agent-toolkit).
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

  cfg = config.biapy.skills.softaworks-agent-toolkit;

  package = pkgs.biapy-parts.softaworks-agent-toolkit;

  skills = {
    agent-md-refactor = "agent-md-refactor/skills/agent-md-refactor";
    backend-to-frontend-handoff-docs = "backend-to-frontend-handoff-docs/skills/backend-to-frontend-handoff-docs";
    c4-architecture = "c4-architecture/skills/c4-architecture";
    codex = "codex/skills/codex";
    command-creator = "command-creator/skills/command-creator";
    commit-work = "commit-work/skills/commit-work";
    crafting-effective-readmes = "crafting-effective-readmes/skills/crafting-effective-readmes";
    daily-meeting-update = "daily-meeting-update/skills/daily-meeting-update";
    database-schema-designer = "database-schema-designer/skills/database-schema-designer";
    datadog-cli = "datadog-cli/skills/datadog-cli";
    dependency-updater = "dependency-updater/skills/dependency-updater";
    design-system-starter = "design-system-starter/skills/design-system-starter";
    difficult-workplace-conversations = "difficult-workplace-conversations/skills/difficult-workplace-conversations";
    domain-name-brainstormer = "domain-name-brainstormer/skills/domain-name-brainstormer";
    draw-io = "draw-io/skills/draw-io";
    excalidraw = "excalidraw/skills/excalidraw";
    feedback-mastery = "feedback-mastery/skills/feedback-mastery";
    frontend-to-backend-requirements = "frontend-to-backend-requirements/skills/frontend-to-backend-requirements";
    game-changing-features = "game-changing-features/skills/game-changing-features";
    gemini = "gemini/skills/gemini";
    gepetto = "gepetto/skills/gepetto";
    humanizer = "humanizer/skills/humanizer";
    jira = "jira/skills/jira";
    lesson-learned = "lesson-learned/skills/lesson-learned";
    marp-slide = "marp-slide/skills/marp-slide";
    meme-factory = "meme-factory/skills/meme-factory";
    mermaid-diagrams = "mermaid-diagrams/skills/mermaid-diagrams";
    mui = "mui/skills/mui";
    naming-analyzer = "naming-analyzer/skills/naming-analyzer";
    openapi-to-typescript = "openapi-to-typescript/skills/openapi-to-typescript";
    perplexity = "perplexity/skills/perplexity";
    plugin-forge = "plugin-forge/skills/plugin-forge";
    professional-communication = "professional-communication/skills/professional-communication";
    qa-test-planner = "qa-test-planner/skills/qa-test-planner";
    react-dev = "react-dev/skills/react-dev";
    react-useeffect = "react-useeffect/skills/react-useeffect";
    reducing-entropy = "reducing-entropy/skills/reducing-entropy";
    requirements-clarity = "requirements-clarity/skills/requirements-clarity";
    session-handoff = "session-handoff/skills/session-handoff";
    ship-learn-next = "ship-learn-next/skills/ship-learn-next";
    skill-judge = "skill-judge/skills/skill-judge";
    web-to-markdown = "web-to-markdown/skills/web-to-markdown";
    writing-clearly-and-concisely = "writing-clearly-and-concisely/skills/writing-clearly-and-concisely";
  };
in
{
  options.biapy.skills.softaworks-agent-toolkit = {
    enable = mkEnableOption "Softaworks agent skills";

    skills = mkOption {
      type = listOf (enum (builtins.attrNames skills));
      default = [
        "c4-architecture"
        "mermaid-diagrams"
        "naming-analyzer"
        "skill-judge"
        "writing-clearly-and-concisely"
      ];
      description = "The Softaworks skills to install.";
      example = [
        "c4-architecture"
        "mermaid-diagrams"
        "naming-analyzer"
        "react-dev"
        "react-useeffect"
      ];
    };
  };

  config = mkIf cfg.enable {
    biapy.programs.gh.enable = mkDefault true;

    biapy.ai.skills.skills = builtins.listToAttrs (
      map (name: {
        inherit name;
        value = "${package}/${skills.${name}}";
      }) cfg.skills
    );
  };
}
