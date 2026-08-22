/**
  # Tasks runners

  ## 🛠️ Tech Stack

  ### Tasks runners

  - [Just homepage](https://just.systems/)
    ([Just @ GitHub](https://github.com/casey/just)).
  - [Taskfile homepage](https://taskfile.dev/)
    ([Taskfile @ GitHub](https://github.com/go-task/task)).
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

  cfg = config.biapy.dev.task-runners;
in
{
  options = {
    biapy.dev.task-runners = {
      enable = mkEnableOption "task runners";
    };
  };

  config = mkIf cfg.enable {
    biapy.dev = {
      containers.enable = mkDefault true;
      dev-environments.enable = mkDefault true;
      k8s.enable = mkDefault true;
      nix.enable = mkDefault true;
    };

    home.packages = with pkgs; [
      just
      go-task
    ];
  };

}
