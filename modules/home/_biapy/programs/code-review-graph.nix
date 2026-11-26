/**
  # code-review-graph

  Local-first code intelligence graph for MCP and CLI.
  Builds a persistent map of your codebase so AI coding tools read only what matters,
  with benchmarked context reductions on reviews and large-repo workflows.

  ## 🛠️ Tech Stack

  - [code-review-graph homepage](https://code-review-graph.com/).
    ([code-review-graph @ GitHub](https://github.com/tirth8205/code-review-graph)).

  ### 🤖 Agent skills

  - [code-review-graph skills @ GitHub](https://github.com/tirth8205/code-review-graph/tree/staging/skills).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) bool;

  cfg = config.biapy.programs.code-review-graph;
in
{
  options.biapy.programs.code-review-graph = {
    enable = mkEnableOption "code-review-graph";

    package = mkPackageOption pkgs.llm-agents "code-review-graph" { };

    withSkills = mkOption {
      type = bool;
      default = true;
      description = "Install the code-review-graph agent skills.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    biapy.ai.skills.skills = mkIf cfg.withSkills {
      build-graph = mkDefault "${cfg.package}/lib/python3.14/site-packages/code_review_graph/_bundled_skills/build-graph";
      debug-issue = mkDefault "${cfg.package}/lib/python3.14/site-packages/code_review_graph/_bundled_skills/debug-issue";
      explore-codebase = mkDefault "${cfg.package}/lib/python3.14/site-packages/code_review_graph/_bundled_skills/explore-codebase";
      refactor-safely = mkDefault "${cfg.package}/lib/python3.14/site-packages/code_review_graph/_bundled_skills/refactor-safely";
      review-changes = mkDefault "${cfg.package}/lib/python3.14/site-packages/code_review_graph/_bundled_skills/review-changes";
      review-delta = mkDefault "${cfg.package}/lib/python3.14/site-packages/code_review_graph/_bundled_skills/review-delta";
      review-pr = mkDefault "${cfg.package}/lib/python3.14/site-packages/code_review_graph/_bundled_skills/review-pr";
    };
  };
}
