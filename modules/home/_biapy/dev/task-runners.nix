/**
  # Tasks runners

  ## 🛠️ Tech Stack

  - [Just homepage](https://just.systems/)
    ([Just @ GitHub](https://github.com/casey/just))
    is a handy way to save and run project-specific commands.
  - [Taskfile homepage](https://taskfile.dev/)
    ([Taskfile @ GitHub](https://github.com/go-task/task))
    is a fast, cross-platform build tool inspired by Make,
    designed for modern workflows.

  ## 🙇 Acknowledgements

  - [How do I deal with a new package whose binary name is identical to an
    existing one? @ nixOS discourse](https://discourse.nixos.org/t/how-do-i-deal-with-a-new-package-whose-binary-name-is-identical-to-an-existing-one/35231).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.dev.task-runners;
in
{
  options.biapy.dev.task-runners.enable = mkEnableOption "task runners";

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        just
      ];

      shellAliases.tsk = getExe' pkgs.go-task "task";
    };
  };

}
