/**
  # Nix tools

  ## 🛠️ Tech Stack

  - [nix-graph @ GitHub](https://github.com/AlexAntonik/nix-graph)
    is an interactive TUI viewer for Nix dependency graphs.
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

  ## 📝 Documentation

  - [nil LSP Configuration @ GitHub](https://github.com/oxalica/nil/blob/main/docs/configuration.md).
  - [nixd LSP Configuration @ GitHub](https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.dev.nix;
in
{
  options.biapy.dev.nix.enable = mkEnableOption "nix development tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unstable.nix-graph
      nil
      nix-output-monitor
      nixd
      nixf
      nixf-diagnose
      nixfmt-rs
      nurl
      statix
    ];

    programs = {
      opencode.settings.lsp.nil = mkDefault {
        command = [ (getExe pkgs.nil) ];
        extensions = [ ".nix" ];
        initialization = {
          formatting.command = [
            (getExe pkgs.nixfmt-rs)
            "-"
          ];
        };
        # opencode supports nixd natively
      };

      zed-editor = {
        extensions = [ "nix" ];

        userSettings = {
          languages.Nix = {
            formatter.external = {
              command = mkDefault (getExe pkgs.nixfmt-rs);
              arguments = mkDefault [ "-" ];
            };
            language_servers = mkDefault [
              "nixd"
              "nil"
            ];
          };
          lsp.nil = mkDefault {
            initialization_options.formatting.command = [
              (getExe pkgs.nixfmt-rs)
              "-"
            ];
          };
        };
      };
    };
  };
}
