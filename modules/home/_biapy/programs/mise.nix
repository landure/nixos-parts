/**
  # mise-en-place

  `mise` is a development environment manager.

  ## 🛠️ Tech Stack

  - ([mise-en-place homepage](https://mise.jdx.dev/))
    ([mise @ GitHub](https://github.com/jdx/mise)).
  - [uv](https://docs.astral.sh/uv/)
    ([uv @ GitHub](https://github.com/astral-sh/uv)).
  - [fnox homepage](https://fnox.jdx.dev/)
    ([fnox @ GitHub](https://github.com/jdx/fnox),
    [fnox-flake @ GitHub](https://github.com/deepwatrcreatur/fnox-flake)).

  ### Mise plugins

  - [verzly/mise-php @ GitHub](https://github.com/verzly/mise-php).
  - [mise-nix @ GitHub](https://github.com/jbadeau/mise-nix).
  - [mise-env-fnox @ GitHub](https://github.com/jdx/mise-env-fnox).

  ### Third-party tools

  - [mise VS Code homepage](https://hverlin.github.io/mise-vscode/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.mise](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enable).

  ## 🙇 Acknowledgements

  - [La veille des Ours n°31 @ Bearstech's LinkedIn :fr:](https://www.linkedin.com/pulse/la-veille-des-ours-n31-bearstech-gbmgf/).
  - [Adieu `direnv`, Bonjour `mise` @ Julien Wittouck :fr:](https://codeka.io/2025/12/19/adieu-direnv-bonjour-mise/).
  - [Mon environnement de développement avec mise et chez-moi @ À l'encre rouillée :fr:](https://david.drugeon-hamon.bzh/blog/2026/02/env-dev-avec-mise-et-chezmoi/).
  - [Mise-en-place & Fnox : mon setup de gestion multi-projets @ Rémi Tech Notes :fr:](https://www.vrchr.fr/posts/2026/04/28/mise-en-place-fnox-setup-multi-projets/).
  - [Mise + Krew : vos plugins kubectl en mode déclaratif @ Une Tasse de Café :fr:](https://une-tasse-de.cafe/expresso/mise-krew/).
  - [Mise : un multi-outil pour votre poste de Dev & Ops @ Devoxx France's YouTube :fr:](https://www.youtube.com/watch?v=ZEtc6WnreI0).
  - [mise : le gestionnaire de versions polyvalent et rapide @ DevSecOps :fr:](https://blog.stephane-robert.info/docs/outils/systeme/mise/).
  - [Best Practices for Using Mise to Maintain Project Structure and Manage Environment Variables @ combray's blog](https://combray.prose.sh/2025-11-26-mise-project-structure-env-vars).
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

  cfg = config.biapy.programs.mise;
in
{
  options = {
    biapy.programs.mise = {
      enable = mkEnableOption "mise";
    };
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      mx = mkDefault "mise exec";
      mr = mkDefault "mise run";
    };

    programs = {
      # Enable uv to provide uvx for pipx backend.
      uv.enable = mkDefault true;

      mise = {
        enable = mkDefault true;

        globalConfig = {
          settings = {
            experimental = mkDefault true;
            verbose = mkDefault false;

            # prevent most supply chain attacks
            minimum_release_age = mkDefault "7d";

            # Aqua backend SecOps
            aqua = {
              cosign = mkDefault true; # Cosign checks (sigstore signatures)
              slsa = mkDefault true; # SLSA checks (builds provenance)
              github_attestations = mkDefault true; # GitHub Actions attestations
            };

            pipx.uvx = mkDefault true;
          };

          plugins = {
            nix = mkDefault "https://github.com/jbadeau/mise-nix";
            php = mkDefault "https://github.com/verzly/mise-php#latest";
            # fnox-env = mkDefault "https://github.com/jdx/mise-env-fnox";
          };

          env = {
            _ = {
              # fnox-env = {
              #   tools = mkDefault true;
              # };
              php = {
                pie_extensions = mkDefault "xdebug/xdebug";
              };
            };
          };
          # tools = {
          #   trivy = {
          #     # trivy updates are time-sensitive, use a shorter window
          #     minimum_release_age = mkDefault "1d";
          #   };
          # };
        };
      };
    };
  };
}
