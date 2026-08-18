/**
  # Nix tools

  ## 🛠️ Tech Stack

  - [nil @ GitHub](https://github.com/oxalica/nil).
  - [nixd @ GitHub](https://github.com/nix-community/nixd).
  - [nixf-diagnose @ GitHub](https://github.com/inclyc/nixf-diagnose).
  - [nixfmt-rs](https://mic92.github.io/nixfmt-rs/)
    ([nixfmt-rs @ GitHub](https://github.com/Mic92/nixfmt-rs)).
  - [nurl @ GitHub](https://github.com/nix-community/nurl)
    generates Nix fetcher calls from URLs
  - [statix @ GitHub](https://github.com/oppiliappan/statix).
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

  cfg = config.biapy.dev.nix;

in
{
  options = {
    biapy.dev.nix.enable = mkEnableOption "nix development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nil
      nixd
      nixf-diagnose
      nixfmt-rs
      nurl
      statix
    ];
  };
}
