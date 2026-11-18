/**
  # ast-grep

  `ast-grep` is a CLI tool for code structural search, lint and rewriting.

  ## 🛠️ Tech Stack

  - [ast-grep homepage](https://ast-grep.github.io/).
    ([ast-grep @ GitHub](https://github.com/ast-grep/ast-grep)).

  ### 🤖 Agent skills

  - [ast-grep agent-skill @ GitHub](https://github.com/ast-grep/agent-skill).
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

  cfg = config.biapy.programs.ast-grep;

  skill = pkgs.fetchFromGitHub {
    owner = "ast-grep";
    repo = "agent-skill";
    rev = "0613dc7f82bbfb3b557380b54726b92f73358460";
    hash = "sha256-HFZVX/UYsct8EMtkczBGJNr9RjjDz77zY6SHS1WlKkc=";
  };

in
{
  options.biapy.programs.ast-grep = {
    enable = mkEnableOption "ast-grep";

    package = mkPackageOption pkgs "ast-grep" { };

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install the ast-grep agent skills.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    biapy.ai.skills.skills = mkIf cfg.withSkill {
      ast-grep = mkDefault "${skill}/ast-grep/skills/ast-grep";
      ast-grep-outline = mkDefault "${skill}/ast-grep/skills/outline";
    };

    # Install the Claude Code plugin only when Claude Code is enabled.
    programs.claude-code.plugins = mkIf cfg.withSkill [
      "${skill}/ast-grep"
    ];
  };
}
