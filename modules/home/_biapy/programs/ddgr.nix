/**
  # ddgr

  ddgr queries 🦆 DuckDuckGo search engine from the terminal.

  ## 🛠️ Tech Stack

  - [ddgr @ GitHub(https://github.com/jarun/ddgr).

  ### 🤖 Agent skills

  - [ddgr-skill @ GitHub](https://github.com/ysm-dev/ddgr-skill).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;

  cfg = config.biapy.programs.ddgr;
in
{
  options.biapy.programs.ddgr = {
    enable = mkEnableOption "ddgr";

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install the ddgr agent skill.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ddgr # DuckDuckGo search CLI client
    ];

    biapy.ai.skills.skills = mkIf cfg.withSkill {
      ddgr = mkDefault ../../../../skills/ddgr;
    };
  };
}
