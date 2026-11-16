{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.ai.software-factory;

in
{
  options.biapy.ai.software-factory.enable = mkEnableOption "AI software factory";

  config = mkIf cfg.enable {
    biapy = {
      ai = {
        agent-skills.enable = mkDefault true;
        mcp-servers.enable = mkDefault true;
        skills.enable = mkDefault true;
      };
      skills = {
        jeffallan-claude-skills.enable = mkDefault true;
        mattpocock-skills.enable = mkDefault true;
        ponytail.enable = mkDefault true;
      };
    };
  };
}
