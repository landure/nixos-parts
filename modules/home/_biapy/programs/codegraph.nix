/**
  # CodeGraph

  CodeGraph is a pre-indexed code knowledge graph,
  that auto syncs on code changes.

  ## 🛠️ Tech Stack

  - [CodeGraph homepage](https://colbymchenry.github.io/codegraph/).
  - [CodeGraph @ GitHub](https://github.com/colbymchenry/codegraph).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.codegraph;
in
{
  options.biapy.programs.codegraph.enable = mkEnableOption "CodeGraph";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ unstable.codegraph ];
  };
}
