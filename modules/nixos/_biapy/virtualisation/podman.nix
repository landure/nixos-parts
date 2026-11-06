/**
  # Podman

  ## 🛠️ Tech Stack

  - [Podman homepage](https://podman.io/).
  - [podman-compose @ GitHub](https://github.com/containers/podman-compose).
  - [NVIDIA Container Toolkit homepage](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)
    ([NVIDIA Container Toolkit @ GitHub](https://github.com/NVIDIA/nvidia-container-toolkit)).

  ### 🐚 TUI

  - [ctop homepage](https://ctop.sh/)
    ([ctop @ GitHub](https://github.com/bcicen/ctop))
    is a Docker monitoring TUI, showing running container resources usage.
  - [DockMate 🐳 @ GitHub](https://github.com/shubh-io/dockmate)
    is an open-source Docker TUI & Podman manager for terminal productivity.
  - [dtop homepage](https://dtop.dev/)
    ([dtop @ GitHub](https://github.com/amir20/dtop)).
    is a terminal dashboard for Docker monitoring across multiple hosts
    with Dozzle integration.
  - [LazyDocker](https://github.com/jesseduffield/lazydocker)
    is a Docker TUI.
  - [Podman TUI](https://github.com/containers/podman-tui).

  ## 📝 Documentation

  - [virtualisation.podman @ NixOS reference](https://search.nixos.org/options?query=virtualisation.podman.).
  - [virtualisation.containers @ NixOS reference](https://search.nixos.org/options?query=virtualisation.containers.).
  - [virtualisation.oci-containers @ NixOS reference](https://search.nixos.org/options?query=virtualisation.oci-containers.).
  - [hardware.nvidia-container-toolkit. @ NixOS reference](https://search.nixos.org/options?query=hardware.nvidia-container-toolkit.).

  ## 🙇 Acknowledgements

  - [Podman @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Podman).
  - [Taming Container Log Sprawl with Podman and systemd-journald @ ShieldedBytes](https://linuxeries.org/post/2026-06-04-taming-container-log-sprawl-with-podman-and-s/).
  - [CTOP, le htop pour conteneurs ! @ Tips4tech.fr :fr:](https://blog.tips4tech.fr/ctop-le-htop-pour-conteneurs/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) attrNames;
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.virtualisation.podman;
in
{
  options.biapy.virtualisation.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    users.groups.podman.members = attrNames config.home-manager.users;

    hardware.nvidia-container-toolkit.enable = mkDefault (config.hardware.facter.detected.graphics.nvidia.enable or false);

    virtualisation = {
      containers.registries.search = [ "docker.io" ];

      oci-containers.backend = mkDefault "podman";

      podman = {
        enable = mkDefault true;
        # Create an alias mapping podman to docker
        dockerCompat = mkDefault true;
        dockerSocket.enable = mkDefault true;

        autoPrune = {
          enable = mkDefault true;
          # flags = [ "--build" ];
        };
      };
    };

    environment.defaultPackages = with pkgs; [
      ctop
      dockmate
      dtop
      lazydocker
      podman-compose
      podman-tui
    ];
  };
}
