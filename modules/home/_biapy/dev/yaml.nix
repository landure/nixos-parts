/**
  # YAML command-line tools

  ## 🛠️ Tech Stack

  - [yamlfmt @ GitHub](https://github.com/google/yamlfmt)
    is an extensible command line tool or library to format yaml files.
  - [yq homepage](https://mikefarah.gitbook.io/yq/)
    ([yq @ GitHub](https://github.com/mikefarah/yq))
    is a lightweight and portable command-line YAML, JSON, INI,
    and XML processor.
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

  cfg = config.biapy.dev.yaml;

in
{
  options.biapy.dev.yaml.enable = mkEnableOption "YAML command-line tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yamlfmt
      yq-go
    ];
  };
}
