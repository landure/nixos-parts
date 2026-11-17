/**
  # Cloudflare's security-audit

  A coding-agent skill for multi-phase security audits
  with independently verified, machine-readable findings.

  ## 🛠️ Tech Stack

  - [security-audit @ GitHub](https://github.com/cloudflare/security-audit-skill).

  ## 🙇 Acknowledgements

  - [Build your own vulnerability harness @ Cloudflare](https://blog.cloudflare.com/build-your-own-vulnerability-harness/).
  - [Cloudflare security-audit : prendre en main la skill d’audit de sécurité pour agents IA @ IT-Connect :fr:](https://www.it-connect.fr/cloudflare-security-audit-skill-audit-de-securite-agents-ia/).
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

  cfg = config.biapy.skills.cloudflare-security-audit-skill;

  package = pkgs.biapy-parts.cloudflare-security-audit-skill;

in
{
  options.biapy.skills.cloudflare-security-audit-skill.enable =
    mkEnableOption "Cloudflare's security-audit skill";

  config = mkIf cfg.enable {
    biapy.ai.skills.skills."security-audit" = mkDefault "${package}/skills/security-audit";
  };
}
