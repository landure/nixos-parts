/**
  # Agent Skills

  ## 🛠️ Tech Stack

  - [skills.sh homepage](https://www.skills.sh/).
    ([skills @ GitHub](https://github.com/vercel-labs/skills)).
  - [Agent Package Manager (APM) homepage](https://microsoft.github.io/apm/)
    ([Agent Package Manager (APM) @ GitHub](https://github.com/microsoft/apm)).
    is an open-source, community-driven dependency manager for AI agents.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.ai.agent-skills;

in
{
  options.biapy.ai.agent-skills.enable = mkEnableOption "AI agents skills tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ctx7
      llm-agents.apm
    ];

    biapy.programs.skills.enable = mkDefault true;
  };
}
