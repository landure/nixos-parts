/**
  # Nix tools

  ## 🛠️ Tech Stack

  - [nix-init @ GitHub](https://github.com/nix-community/nix-init)
    generates Nix packages from URLs.
  - [nix-graph @ GitHub](https://github.com/AlexAntonik/nix-graph)
    is an interactive TUI viewer for Nix dependency graphs.
  - [nix-inspect @ GitHub](https://github.com/bluskript/nix-inspect)
    is an interactive tui for inspecting nix configs.
  - [nix-output-monitor @ GitHub](https://github.com/maralorn/nix-output-monitor)
    parse nix build output to give additional information while building.
  - [nixd @ GitHub](https://github.com/nix-community/nixd)
    is a Nix language server, based on nix libraries.
  - [nixf-diagnose @ GitHub](https://github.com/inclyc/nixf-diagnose)
    is a Nix linter based on `libnixf`.
  - [nixos-rebuild-ng @ GitHub](https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-rebuild-ng).
  - [nurl @ GitHub](https://github.com/nix-community/nurl)
    generates Nix fetcher calls from URLs
  - [statix @ GitHub](https://github.com/oppiliappan/statix)
    provides lints and suggestions for the nix programming language.

  ## 📝 Documentation

  - [nixd LSP Configuration @ GitHub](https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md).

  ### 🏠 Home Manager

  - [programs.nix-init @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/nix-init.html).
  - [programs.nix-init @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.nix-init.).
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

  cfg = config.biapy.dev.nix;
in
{
  options.biapy.dev.nix.enable = mkEnableOption "nix development tools";

  config = mkIf cfg.enable {
    biapy.programs = {
      nixfmt-rs.enable = mkDefault true;
      nil.enable = mkDefault true;
    };

    home.packages = with pkgs; [
      unstable.nix-graph
      nix-eval-jobs
      nix-inspect
      nix-output-monitor
      nixd
      nixf
      nixf-diagnose
      nixos-rebuild-ng
      nurl
      statix
    ];

    programs = {
      nix-init.enable = mkDefault true;

      zed-editor = {
        extensions = [ "nix" ];
      };
    };
  };
}
