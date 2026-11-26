/**
  # mq

  `mq` is a command-line tool that processes Markdown using a syntax similar
  to jq: slice, filter, map and transform structured Markdown.

  ## 🛠️ Tech Stack

  - [mq homepage](https://mqlang.org).
    ([mq @ GitHub](https://github.com/harehare/mq)).

  ### 🤖 Agent skills

  - [mq skills @ GitHub](https://github.com/harehare/mq/tree/main/skills).
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

  cfg = config.biapy.programs.mq;
in
{
  options.biapy.programs.mq = {
    enable = mkEnableOption "mq";

    package = mkPackageOption pkgs.biapy-parts "mq" { };

    withSkills = mkOption {
      type = bool;
      default = true;
      description = "Install the mq agent skills.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    biapy.ai.skills.skills = mkIf cfg.withSkills {
      processing-markdown = mkDefault "${cfg.package}/skills/processing-markdown";
      web-scraping = mkDefault "${cfg.package}/skills/web-scraping";
    };
  };
}
