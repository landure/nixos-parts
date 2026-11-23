/**
  # Architecture Decision Record

  Agent skill for writing Architecture Decision Records (ADRs): decide whether
  a decision deserves an ADR, set up an `adr/` or `decisions/` directory, name
  the file, pick a template, and write the Context/Decision/Consequences
  sections.

  ## 🛠️ Tech Stack

  - [Architecture Decision Record @ GitHub](https://github.com/architecture-decision-record/architecture-decision-record).
  - [Architecture Decision Record homepage](https://architecture-decision-record.github.io/).
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

  cfg = config.biapy.skills.architecture-decision-record;

  package = pkgs.biapy-parts.architecture-decision-record;

  skills = [
    "architecture-decision-record-skill"
    "architecture-decision-record-maintainer-skill"
  ];
in
{
  options.biapy.skills.architecture-decision-record = {
    enable = mkEnableOption "Architecture Decision Record agent skills";

    skills = mkOption {
      type = listOf (enum skills);
      default = [
        "architecture-decision-record-skill"
      ];
      description = "The Architecture Decision Record skills to install.";
      example = [
        "architecture-decision-record-skill"
        "architecture-decision-record-maintainer-skill"
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
