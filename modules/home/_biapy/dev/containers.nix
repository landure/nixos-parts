/**
  # Docker TUI tools

  ## 🛠️ Tech Stack

  - [nerdctl @ GitHub](https://github.com/containerd/nerdctl).
  - [layerx @ GitHub](https://github.com/deveshctl/layerx).
  - [dive @ GitHub](https://github.com/wagoodman/dive).

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

  ### 🏠 Home Manager

  - [programs.lazydocker](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lazydocker.enable).

  ## 🙇 Acknowledgements

  - [CTOP, le htop pour conteneurs ! @ Tips4tech.fr :fr:](https://blog.tips4tech.fr/ctop-le-htop-pour-conteneurs/).
  - [Analysez vos images Docker avec Dive @ DevSecOps :fr:](https://blog.stephane-robert.info/docs/conteneurs/outils/dive/).
  - [dtop @ GitHub](https://github.com/StakeSquid/dtop).
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

  cfg = config.biapy.dev.containers;

in
{
  options.biapy.dev.containers.enable = mkEnableOption "container command-line tools";

  config = mkIf cfg.enable {
    programs.lazydocker.enable = mkDefault true;

    home = {
      shellAliases = {
        pc = mkDefault "podman compose";
        pr = mkDefault "podman run";
        podip = mkDefault "podman container inspect --format '{{range $name, $settings := .NetworkSettings.Networks}}{{print $name}}:{{println $settings.IPAddress}}{{end}}'";
        pnls = mkDefault "podman network inspect --format '{{range $cid, $settings := .Containers}}{{print $settings.Name}} : {{println $settings.IPv4Address}}{{end}}'";

        dc = mkDefault "docker compose";
        dr = mkDefault "docker run";
        dockip = mkDefault "docker container inspect --format '{{range $name, $settings := .NetworkSettings.Networks}}{{print $name}}:{{println $settings.IPAddress}}{{end}}'";
        dnls = mkDefault "docker network inspect --format '{{range $cid, $settings := .Containers}}{{print $settings.Name}} : {{println $settings.IPv4Address}}{{end}}'";
      };

      packages = with pkgs; [
        ctop # Docker TUI, showing running container resources usage
        dockmate
        dtop
        dive
        podman-tui
        nerdctl
        unstable.layerx

        (pkgs.writeShellScriptBin "dockvol" ''
          # List container volumes
          test -n "''${1}" &&
          docker container inspect "''${1}" |
          ${getExe config.programs.jq.package} ".[0].HostConfig | {Binds, Mounts}" |
          ${getExe config.programs.bat.package} --language="json"
        '')

        (pkgs.writeShellScriptBin "dnip" ''
          # Output IP address ranges of each docker network.
          if ! type -f 'docker' >'/dev/null'; then
            echo "Error: docker command not available."
          fi

          docker network ls --format='{{ .Name }}' |
            xargs docker network inspect --format='{{ .Name }}
            {{- range $subnet, $settings := .Status.IPAM.Subnets -}}
            {{- printf " : %s" $subnet -}}
            {{- end }}'
        '')
      ];
    };
  };
}
