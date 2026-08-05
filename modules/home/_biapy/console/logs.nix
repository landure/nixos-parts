/**
  # command-line and TUI logs tools

  ## 🛠️ Tech Stack

  - [lnav homepage](https://lnav.org/)
    ([lnav @ GitHub](https://github.com/tstack/lnav)).
  - [LazyJournal @ GitHub](https://github.com/Lifailon/lazyjournal).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.console.logs;
in
{
  options = {
    biapy.console.logs = {
      enable = mkEnableOption "logs tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lnav
      lazyjournal
    ];
  };
}
