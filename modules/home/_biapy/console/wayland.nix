/**
  # Wayland command-line tools

  ## 🛠️ Tech Stack

  - [grim @ sourcehut](https://sr.ht/~emersion/grim/)
    grab images from a Wayland compositor.
  - [slurp @ GitHub](https://github.com/emersion/slurp)
    selects a region in a Wayland compositor and print it to the standard output.
  - [wl-clipboard-rs @ GitHub](https://github.com/YaLTeR/wl-clipboard-rs)
    is a safe Rust crate for working with the Wayland clipboard.
  - [wl-screenrec @ GitHub](https://github.com/russelltg/wl-screenrec).
    is a high performance screen recorder for wlroots Wayland.
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

  cfg = config.biapy.console.wayland;
in
{
  options = {
    biapy.console.wayland = {
      enable = mkEnableOption "Wayland command-line tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard-rs
      wl-screenrec
    ];
  };
}
