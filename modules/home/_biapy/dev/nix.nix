/**
  # Nix tools

  ## 🛠️ Tech Stack

  - [nix-output-monitor @ GitHub](https://github.com/maralorn/nix-output-monitor)
    parse nix build output to give additional information while building.
  - [nil @ GitHub](https://github.com/oxalica/nil)
    is a nix Language server, an incremental analysis assistant for writing in Nix.
  - [nixd @ GitHub](https://github.com/nix-community/nixd)
    is a Nix language server, based on nix libraries.
  - [nixf-diagnose @ GitHub](https://github.com/inclyc/nixf-diagnose)
    is a Nix linter based on `libnixf`.
  - [nixfmt-rs](https://mic92.github.io/nixfmt-rs/)
    ([nixfmt-rs @ GitHub](https://github.com/Mic92/nixfmt-rs))
    is a from-scratch Rust reimplementation of `nixfmt` that produces
    byte-identical output to the Haskell original.
  - [nurl @ GitHub](https://github.com/nix-community/nurl)
    generates Nix fetcher calls from URLs
  - [statix @ GitHub](https://github.com/oppiliappan/statix)
    provides lints and suggestions for the nix programming language.
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
      nix-output-monitor
      nixd
      nixf
      nixf-diagnose
      nixfmt-rs
      nurl
      statix
    ];
  };
}
