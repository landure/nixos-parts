/**
  # duf

  duf is a better `df` alternative: a Disk Usage/Free utility with a nicer TUI.

  ## 🛠️ Tech Stack

  - [duf @ GitHub](https://github.com/muesli/duf/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.biapy.programs.duf;
in
{
  options.biapy.programs.duf = {
    enable = mkEnableOption "duf";
    package = mkPackageOption pkgs "duf" { };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    home.shellAliases = {
      df = mkDefault "duf --hide=special";
    };
  };
}
