/**
  # Hypothesis Debugging

  An agent skill for hypothesis-driven debugging: one testable hypothesis at
  a time, logged and validated in a CSV loop.

  ## 🛠️ Tech Stack

  - [Hypothesis Debugging @ GitHub](https://github.com/ioma8/hypothesis-debugging).

  ## 🙇 Acknowledgements

  - [Hypothesis Debugging @ GitHub](https://github.com/ioma8/hypothesis-debugging) by Jakub Kolcar.
  - [LLM assisted reverse engineering @ Slow Chronicle](https://www.slowchronicle.com/posts/llm-assisted-reverse-engineering).
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

  cfg = config.biapy.skills.hypothesis-debugging;

  package = pkgs.biapy-parts.hypothesis-debugging;

in
{
  options.biapy.skills.hypothesis-debugging.enable =
    mkEnableOption "Hypothesis Debugging agent skill";

  config = mkIf cfg.enable {
    biapy.ai.skills.skills."hypothesis-debugging" = mkDefault "${package}/skills/hypothesis-debugging";
  };
}
