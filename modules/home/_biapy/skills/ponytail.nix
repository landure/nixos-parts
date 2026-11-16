/**
  # Ponytail

  Makes your AI agent think like the laziest senior dev in the room.
  The best code is the code you never wrote.

  ## 🛠️ Tech Stack

  - [Ponytail homepage](https://ponytail.dev/).
  - [Ponytail @ GitHub](https://github.com/DietrichGebert/ponytail).
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

  cfg = config.biapy.skills.ponytail;

  package = pkgs.biapy-parts.ponytail;

in
{
  options.biapy.skills.ponytail.enable = mkEnableOption "Ponytail";

  config = mkIf cfg.enable {
    biapy.ai.skills.skills = {
      "ponytail-audit" = mkDefault "${package}/skills/ponytail-audit";
      "ponytail-debt" = mkDefault "${package}/skills/ponytail-debt";
      "ponytail-gain" = mkDefault "${package}/skills/ponytail-gain";
      "ponytail-help" = mkDefault "${package}/skills/ponytail-help";
      "ponytail-review" = mkDefault "${package}/skills/ponytail-review";
      "ponytail" = mkDefault "${package}/skills/ponytail";
    };

    programs.opencode.settings = {
      plugins = [ "${package}/.opencode/plugins" ];
    };
  };
}
