/**
  # Agent Skills

  ## 🛠️ Tech Stack

  - [skills.sh homepage](https://www.skills.sh/).
    ([skills @ GitHub](https://github.com/vercel-labs/skills)).
*/
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.ai.agent-skills;

in
{
  options = {
    biapy.ai.agent-skills.enable = mkEnableOption "AI agents skills tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      skills
      ctx7
    ];
  };
}
