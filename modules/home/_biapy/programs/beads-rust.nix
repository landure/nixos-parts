/**
  # Beads (Rust)

  `br` is a local-first, dependency-aware issue tracker for git repositories,
  designed for AI agents.

  This module installs the `beads-rust` package from the `llm-agents` flake
  together with the official `br` agent skill.

  ## 🛠️ Tech Stack

  - [beads_rust @ GitHub](https://github.com/Dicklesworthstone/beads_rust).
  - [llm-agents.nix @ GitHub](https://github.com/numtide/llm-agents.nix).

  ### 🤖 Agent skills

  - [br agent skill @ GitHub](https://github.com/Dicklesworthstone/beads_rust/tree/main/.claude/skills/br).
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

  cfg = config.biapy.programs.beads-rust;

  skill = pkgs.fetchFromGitHub {
    owner = "Dicklesworthstone";
    repo = "beads_rust";
    rev = "0024727a8bbf0510b1ec89ed552b216ddaff4dd8";
    hash = "sha256-DmpH1m5Ro71VH+UK/5vgs0jPuvY7xlz118MOkj26/As=";
  };

in
{
  options.biapy.programs.beads-rust = {
    enable = mkEnableOption "beads-rust";

    package = mkPackageOption pkgs.llm-agents "beads-rust" { };

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install the br agent skill.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    biapy.ai.skills.skills = mkIf cfg.withSkill {
      br = mkDefault "${skill}/.claude/skills/br";
    };
  };
}
