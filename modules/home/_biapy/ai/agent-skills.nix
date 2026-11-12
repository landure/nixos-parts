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
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkDefault mkEnableOption;

  cfg = config.biapy.ai.agent-skills;

in
{
  options = {
    biapy.ai.agent-skills.enable = mkEnableOption "AI agents skills tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ctx7
    ];

    biapy.programs.skills.enable = mkDefault true;
  };
}
