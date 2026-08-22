/**
  # Command-line software development tools

  ## 🛠️ Tech Stack

  - [ast-grep homepage](https://ast-grep.github.io/)
    ([ast-grep @ GitHub](https://github.com/ast-grep/ast-grep))
    is a CLI tool for code structural search, lint and rewriting..
  - [sd - search & displace @ GitHub](https://github.com/chmln/sd)
    is an intuitive find & replace CLI (`sed` alternative).
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

  cfg = config.biapy.dev.console;
in
{
  options = {
    biapy.dev.console = {
      enable = mkEnableOption "command-line software development tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ast-grep
      sd
    ];
  };

}
