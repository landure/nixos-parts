/**
  # Command-line database clients

  ## 🛠️ Tech Stack

  - [Harlequin homepage](https://harlequin.sh/)
    ([Harlequin @ GitHub](https://github.com/tconbeer/harlequin)).
  - [sqlit @ GitHub](https://github.com/Maxteabag/sqlit).
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

  cfg = config.biapy.dev.tui-db-clients;
in
{
  options = {
    biapy.dev.tui-db-clients = {
      enable = mkEnableOption "command-line database clients";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      harlequin
      sqlit-tui
    ];
  };
}
