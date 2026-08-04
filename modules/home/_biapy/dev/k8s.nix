/**
  # Kubernetes (k8s) tools

  ## 🛠️ Tech Stack

  - [helm homepage](https://helm.sh/)
    ([helm @ GitHub](https://github.com/helm/helm)).
  - [helm-ls @ GitHub](https://github.com/mrjosh/helm-ls)
  - [k9s homepage](https://k9scli.io/ )
    ([k9s @ GitHub](https://github.com/derailed/k9s)).
  - [kail @ GitHub](https://github.com/boz/kail).
  - [kind homepage](https://kind.sigs.k8s.io/)
    ([kind @ GitHub](https://github.com/kubernetes-sigs/kind)).
  - [kubecolor homepage](https://kubecolor.github.io/)
    ([kubecolor @ GitHub](https://github.com/kubecolor/kubecolor))
  - [kubectl @ GitHub](https://github.com/kubernetes/kubectl).
  - [ktop homepage](https://ktop.app/)
    ([ktop @ GitHub](https://github.com/vladimirvivien/ktop)).
  - [kty homepage](https://kty.dev/)
    ([kty @ GitHub](https://github.com/grampelberg/kty)).
  - [stern @ GitHub](https://github.com/stern/stern).
  - [talosctl homepage](https://www.siderolabs.com/talos-linux)
    ([talosctl @ GitHub](https://github.com/siderolabs/talos/tree/main/cmd/talosctl)).
  - [talos-pilot @ GitHub](https://github.com/Handfish/talos-pilot).

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
  pkgs-unstable,
  ...
}:
let
  inherit (lib.meta) getExe;
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
