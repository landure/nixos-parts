/**
  # Graphics tools

  ## 🛠️ Tech Stack

  - [chafa homepage](https://hpjansson.org/chafa/)
    ([chafa @ GitHub](https://github.com/hpjansson/chafa))
    is a command-line utility that converts image data,
    including animated GIFs, into graphics formats
    or ANSI/Unicode character art suitable for display in a terminal.
  - [timg @ GitHub](https://github.com/hzeller/timg)
    is a terminal image and video viewer.

*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.console.graphics;
in
{
  options = {
    biapy.console.graphics = {
      enable = mkEnableOption "command-line graphics tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chafa
      timg
    ];
  };
}
