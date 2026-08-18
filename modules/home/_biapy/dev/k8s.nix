/**
  # Kubernetes (k8s) tools

  ## 🛠️ Tech Stack

  - [helm homepage](https://helm.sh/)
    ([helm @ GitHub](https://github.com/helm/helm))
    is a tool for managing Charts.
    Charts are packages of pre-configured Kubernetes resources.
  - [helm-ls @ GitHub](https://github.com/mrjosh/helm-ls)
    is a Language server for Helm
  - [k9s homepage](https://k9scli.io/ )
    ([k9s @ GitHub](https://github.com/derailed/k9s))
    is a terminal based UI to interact with Kubernetes clusters.
  - [kail @ GitHub](https://github.com/boz/kail)
    is a kubernetes log viewer.
  - [kind homepage](https://kind.sigs.k8s.io/)
    ([kind @ GitHub](https://github.com/kubernetes-sigs/kind))
     is a tool for running local Kubernetes clusters using Docker container “nodes”.
  - [krew homepage](https://krew.sigs.k8s.io/)
    (krew @ GitHub)(https://github.com/kubernetes-sigs/krew)
    is the plugin manager for `kubectl` command-line tool.
  - [kubecolor homepage](https://kubecolor.github.io/)
    ([kubecolor @ GitHub](https://github.com/kubecolor/kubecolor))
     is a `kubectl` wrapper used to add colors to its output.
  - [kubectl @ GitHub](https://github.com/kubernetes/kubectl).
  - [ktop homepage](https://ktop.app/)
    ([ktop @ GitHub](https://github.com/vladimirvivien/ktop))
    is a top-like tool for Kubernetes cluster metrics.
  - [kty homepage](https://kty.dev/)
    ([kty @ GitHub](https://github.com/grampelberg/kty))
    is a terminal for Kubernetes.
  - [stern @ GitHub](https://github.com/stern/stern)
    provides multi pod and container log tailing for Kubernetes.
  - [talosctl homepage](https://www.siderolabs.com/talos-linux)
    ([talosctl @ GitHub](https://github.com/siderolabs/talos/tree/main/cmd/talosctl))
    is Talos Linux command-line tool.
  - [talos-pilot @ GitHub](https://github.com/Handfish/talos-pilot)
    is a Talos TUI for real-time node monitoring, log streaming, etcd health, and diagnostics.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.kubecolor @ Home Manager documentation](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kubecolor.enable).
  - [programs.kubecolor @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.kubecolor.).
  - [programs.kubeswitch @ Home Manager documentation](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kubeswitch.enable).
  - [programs.kubeswitch @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.kubeswitch.).

  ## 🙇 Acknowledgements

  - [Helm and Helmfile @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Helm_and_Helmfile).
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

  cfg = config.biapy.dev.k8s;

in
{
  options = {
    biapy.dev.k8s.enable = mkEnableOption "kubernetes command-line tools";
  };

  config = mkIf cfg.enable {
    biapy.programs.k9s.enable = mkDefault true;

    programs = {
      kubecolor.enable = mkDefault true;
      kubeswitch.enable = mkDefault true;
    };

    home = {
      packages = with pkgs; [
        kail
        kind
        kubectl
        krew
        ktop
        kty
        stern
        talosctl
        talos-pilot
        helm-ls

        (wrapHelm kubernetes-helm {
          plugins = with pkgs.kubernetes-helmPlugins; [
            helm-secrets
            helm-diff
            helm-s3
            helm-git
          ];
        })
      ];
    };
  };
}
