/**
  # k9s

  k9s is a terminal based UI to interact with your Kubernetes clusters.

  ## 🛠️ Tech Stack

  - [k9s homepage](https://k9scli.io/ )
    ([k9s @ GitHub](https://github.com/derailed/k9s)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.k9s @ Home Manager documentation](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.k9s.enable).
  - [programs.k9s @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.k9s.).

  ### 🎨 Stylix

  - [K9s @ Stylix](https://nix-community.github.io/stylix/options/modules/k9s.html).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.k9s;
in
{
  options = {
    biapy.programs.k9s = {
      enable = mkEnableOption "mise";
    };
  };

  config = mkIf cfg.enable {
    programs.k9s = {
      enable = mkDefault true;

      aliases = {
        # Use pp as an alias for Pod
        pp = "v1/pods";
      };

      hotKeys = {
        shift-0 = {
          command = "pods";
          description = "Viewing pods";
          shortCut = "Shift-0";
        };

        plugins = {
          # Defines a plugin to provide a `ctrl-l` shortcut to
          # tail the logs while in pod view.
          fred = {
            shortCut = "Ctrl-L";
            description = "Pod logs";
            scopes = [ "po" ];
            command = "kubectl";
            background = false;
            args = [
              "logs"
              "-f"
              "$NAME"
              "-n"
              "$NAMESPACE"
              "--context"
              "$CLUSTER"
            ];
          };
        };

        views = {
          "v1/pods" = {
            columns = [
              "AGE"
              "NAMESPACE"
              "NAME"
              "IP"
              "NODE"
              "STATUS"
              "READY"
            ];
          };
        };
      };
    };
  };
}
