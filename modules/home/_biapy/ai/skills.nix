/**
  # Centrallized agent skills

  This module defines agent skills available to all agents
  which skills are configurable with home manager.

  It installs skills in `~/.agents/skills`
  and in supported agents skills folders.

  ## 🛠️ Tech Stack

  - [Agent Skills homepage](https://agentskills.io/home)
    ([Agent Skills @ GitHub](https://github.com/agentskills/agentskills)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.codex.skills @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/codex.html#opt-programs.codex.skills).
  - [programs.codex.skills @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.codex.skills).
  - [programs.opencode.skills @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/opencode.html#opt-programs.opencode.skills).
  - [programs.opencode.skills @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.opencode.skills).
  - [programs.claude-code.skills @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/claude-code.html#opt-programs.claude-code.skills).
  - [programs.claude-code.skills @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.claude-code.skills).
  - [programs.antigravity-cli.skills @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/antigravity-cli.html#opt-programs.antigravity-cli.skills).
  - [programs.antigravity-cli.skills @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.antigravity-cli.skills).
  - [programs.github-copilot-cli.skills @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/github-copilot-cli.html#opt-programs.github-copilot-cli.skills).
  - [programs.github-copilot-cli.skills @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.github-copilot-cli.skills).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.attrsets) genAttrs mapAttrs' nameValuePair;
  inherit (lib.filesystem) pathIsDirectory;
  inherit (lib.hm.strings) isPathLike;
  inherit (lib.lists) filter;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types)
    attrsOf
    bool
    lines
    oneOf
    path
    str
    ;

  cfg = config.biapy.ai.skills;

  supportedAgents = [
    "codex"
    "opencode"
    "claude-code"
    "antigravity-cli"
    "github-copilot-cli"
  ];
in
{
  options = {
    biapy.ai.skills = {
      enable = mkEnableOption "Biapy agent skills";
      skills = mkOption {
        type = attrsOf (oneOf [
          lines
          path
          str
        ]);
        default = { };
        description = ''
          Custom skills for AI agents.

          This option can be either:
          - An attribute set defining skills
          - A path to a directory containing skill folders
        '';
      };
    };
  }
  // genAttrs supportedAgents (agent: {
    programs.${agent}.biapy.enableSkillsIntegration = mkOption {
      type = bool;
      default = false;
      description = "Enable biapy skills integration for ${agent}.";
    };
  });

  config = mkIf (cfg.skills != { }) {
    home.file = mkIf cfg.enable (
      mapAttrs' (
        name: content:
        if isPathLike content && pathIsDirectory content then
          nameValuePair ".agents/skills/${name}" {
            source = mkDefault content;
            recursive = mkDefault true;
          }
        else
          nameValuePair ".agents/skills/${name}/SKILL.md" (
            if isPathLike content then { source = content; } else { text = content; }
          )
      ) (if builtins.isAttrs cfg.skills then cfg.skills else { })
    );

    programs =
      genAttrs
        (filter (agent: config.programs.${agent}.biapy.enableSkillsIntegration or true) supportedAgents)
        (_: {
          inherit (cfg) skills;
        });
  };
}
