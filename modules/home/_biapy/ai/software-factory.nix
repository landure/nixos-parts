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

      programs = {
        beads-rust.enable = mkDefault true;
        herdr.enable = mkDefault true;
        sidecar.enable = mkDefault true;
      };

      skills = {
        addyosmani-agent-skills.enable = mkDefault true;
        architecture-decision-record.enable = mkDefault true;
        cloudflare-security-audit-skill.enable = mkDefault true;
        guard-skills.enable = mkDefault true;
        hypothesis-debugging.enable = mkDefault true;
        jeffallan-claude-skills.enable = mkDefault true;
        mattpocock-skills.enable = mkDefault true;
        modern-web-guidance.enable = mkDefault true;
        softaworks-agent-toolkit.enable = mkDefault true;
        planning-with-files.enable = mkDefault true;
        ponytail.enable = mkDefault true;
      };
    };
  };
}
