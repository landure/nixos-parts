/**
  # CodeGraph

  CodeGraph is a pre-indexed code knowledge graph,
  that auto syncs on code changes.

  ## 🛠️ Tech Stack

  - [CodeGraph homepage](https://colbymchenry.github.io/codegraph/).
  - [CodeGraph @ GitHub](https://github.com/colbymchenry/codegraph).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.mcp @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.enable).
  - [programs.mcp.servers.<name>. @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.mcp.servers.%3Cname%3E.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) bool enum listOf;

  cfg = config.biapy.mcp.codegraph;
in
{
  options.biapy.mcp.codegraph = {
    enable = mkEnableOption "CodeGraph";
    package = mkPackageOption pkgs.unstable "codegraph" { };

    withAgentsDotMd = mkOption {
      type = bool;
      default = true;
      description = "Add CodeGraph section to global AGENTS.md";
    };

    withSkills = mkOption {
      type = listOf (enum [
        "codegraph-ast-grep"
      ]);
      default = [
        "codegraph-ast-grep"
      ];
      description = "Install CodeGraph CLI agent skills.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    biapy = {
      programs.ast-grep.enable = mkDefault true;

      skills.stark-ai-de-agent-skills = mkIf (builtins.elem "codegraph-ast-grep" cfg.withSkills) {
        enable = mkDefault true;
        skills = [ "codegraph-ast-grep" ];
      };

      ai.agentsDotMd.contents = mkIf cfg.withAgentsDotMd {
        Tools.CodeGraph = ''
          In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root),
          reach for it BEFORE grep/find or reading files when you need to understand or locate code:

          - **MCP tool** (when available): `codegraph_explore` answers most code questions in one call —
            the relevant symbols' verbatim source plus the call paths between them,
            including dynamic-dispatch hops grep can't follow.
            Name a file or symbol in the query to read its current line-numbered source.
            If it's listed but deferred, load it by name via tool search.
          - **Shell** (always works):
            `codegraph explore "<symbol names or question>"` prints the same output.

          If there is no `.codegraph/` directory,
          skip CodeGraph entirely — indexing is the user's decision.
        '';
      };
    };

    programs.mcp.servers.codegraph = {
      command = mkDefault (getExe cfg.package);
      args = mkDefault [
        "serve"
        "--mcp"
      ];
    };
  };
}
