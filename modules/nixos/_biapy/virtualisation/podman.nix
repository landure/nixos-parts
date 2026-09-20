/**
  # Podman

  ## 🛠️ Tech Stack

  - [Podman homepage](https://podman.io/).
  - [Podman TUI](https://github.com/containers/podman-tui).
  - [LazyDocker](https://github.com/jesseduffield/lazydocker)
    is a Docker TUI.
  - [ctop homepage](https://ctop.sh/)
    ([ctop @ GitHub](https://github.com/bcicen/ctop))
    is a Docker monitoring TUI, showing running container resources usage.
  - [DockMate 🐳 @ GitHub](https://github.com/shubh-io/dockmate)
    is an open-source Docker TUI & Podman manager for terminal productivity.
  - [dtop homepage](https://dtop.dev/)
    ([dtop @ GitHub](https://github.com/amir20/dtop)).
    is a terminal dashboard for Docker monitoring across multiple hosts
    with Dozzle integration.

  ## 📝 Documentation

  - [virtualisation.podman @ NixOS reference](https://search.nixos.org/options?query=virtualisation.podman).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.virtualisation.podman;
in
{
  options.biapy.virtualisation.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = mkDefault true;
      # Create an alias mapping podman to docker
      dockerCompat = mkDefault true;
      dockerSocket.enable = mkDefault true;
    };

    environment.defaultPackages = with pkgs; [
      ctop
      dockmate
      dtop
      lazydocker
      podman-tui
    ];
  };
}
