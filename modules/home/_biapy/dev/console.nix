/**
  # Command-line software development tools

  ## 🛠️ Tech Stack

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
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.dev.console;
in
{
  options.biapy.dev.console.enable = mkEnableOption "command-line software development tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sd
      biapy-parts.rgsd
    ];

    biapy.programs = {
      ast-grep.enable = mkDefault true;
      ripgrep.enable = mkDefault true;
    };
  };
}
