/**
  # stark-ai-de agent skills

  Install selected skills from stark-ai-de's agent-skills repository.

  ## 🛠️ Tech Stack

  - [stark-ai-de/agent-skills @ GitHub](https://github.com/stark-ai-de/agent-skills).
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

  cfg = config.biapy.skills.stark-ai-de-agent-skills;

  package = pkgs.biapy-parts.stark-ai-de-agent-skills;

  skills = {
    claude-memory-curator = "claude-operations/claude-memory-curator";
    claude-spec-interviewer = "claude-operations/claude-spec-interviewer";
    codex-memory-curator = "codex-operations/codex-memory-curator";
    codex-spec-interviewer = "codex-operations/codex-spec-interviewer";
    cursor-memory-curator = "cursor-operations/cursor-memory-curator";
    cursor-spec-interviewer = "cursor-operations/cursor-spec-interviewer";
    animated-readme-logo = "engineering-workflows/animated-readme-logo";
    architecture-compass = "engineering-workflows/architecture-compass";
    architecture-zoom = "engineering-workflows/architecture-zoom";
    codegraph-ast-grep = "engineering-workflows/codegraph-ast-grep";
    drawio-diagrams = "engineering-workflows/drawio-diagrams";
    karakeep-knowledge = "engineering-workflows/karakeep-knowledge";
    telegram-serverless = "engineering-workflows/telegram-serverless";
    visual-reports = "engineering-workflows/visual-reports";
    jev-capability-advisor = "skill-maintenance/jev-capability-advisor";
  };
in
{
  options.biapy.skills.stark-ai-de-agent-skills = {
    enable = mkEnableOption "stark-ai-de agent skills";

    skills = mkOption {
      type = listOf (enum (builtins.attrNames skills));
      default = [ ];
      description = "The stark-ai-de skills to install.";
      example = [
        "architecture-compass"
        "visual-reports"
      ];
    };
  };

  config = mkIf cfg.enable {
    biapy.ai.skills.skills = builtins.listToAttrs (
      map (name: {
        inherit name;
        value = "${package}/skills/${skills.${name}}";
      }) cfg.skills
    );
  };
}
