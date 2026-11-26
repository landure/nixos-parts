/**
  # Emil Kowalski's Skills For Designers and Engineers

  AI Skills for Building Better Interfaces
  By Emil Kowalski, for people who want to build beautiful things.

  ## 🛠️ Tech Stack

  - [AI Skills for Building Better Interfaces](https://aiforui.dev/skills).
  - [Skills For Designers and Engineers @ GitHub](https://github.com/emilkowalski/skills).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum listOf;

  cfg = config.biapy.skills.emilkowalski-skills;

  package = pkgs.biapy-parts.emilkowalski-skills;

  skills = [
    "animate"
    "animate-expo"
    "animation-performance"
    "animation-vocabulary"
    "apple-design"
    "ask-emil"
    "ask-sonner"
    "break-ui"
    "choreograph"
    "emil-design-eng"
    "find-animation-opportunities"
    "gestures"
    "improve-animations"
    "learn-taste"
    "mobile-native"
    "pick-ui-library"
    "prototype"
    "remove-animations"
    "review-animations"
    "write-swift"
  ];
in
{
  options.biapy.skills.emilkowalski-skills = {
    enable = mkEnableOption "Emil Kowalski agent skills";

    skills = mkOption {
      type = listOf (enum skills);
      default = [ ];
      description = "The Emil Kowalski agent skills to install.";
      example = [
        "animate"
        "animation-performance"
        "animation-vocabulary"
        "apple-design"
        "break-ui"
        "choreograph"
        "find-animation-opportunities"
        "gestures"
        "improve-animations"
        "mobile-native"
        "pick-ui-library"
        "prototype"
        "remove-animations"
        "review-animations"
        "write-swift"
      ];
    };
  };

  config = mkIf cfg.enable {
    biapy.ai.skills.skills = builtins.listToAttrs (
      map (name: {
        inherit name;
        value = "${package}/skills/${name}";
      }) cfg.skills
    );
  };
}
