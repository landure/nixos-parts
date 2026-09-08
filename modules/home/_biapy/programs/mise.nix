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

  - [programs.mise @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enable).
  - [programs.mise @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.mise.).

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
    home = {
      shellAliases = {
        mx = mkDefault "mise exec";
        mr = mkDefault "mise run";
      };
    };

    biapy.programs = {
      cargo.enable = mkDefault true;
      go.enable = mkDefault true;
    };

    programs = {
      # Enable uv to provide uvx for pipx backend.
      uv.enable = mkDefault true;

      mise = {
        enable = mkDefault true;

        package = pkgs.unstable.mise;
        # package = pkgs.mise-flake.mise.overrideAttrs (
        #   finalAttrs: previousAttrs: {
        #     checkPhase = previousAttrs.checkPhase + '' \
        #       --skip agecrypt::plugin_tests::plugin_protocol_roundtrip_and_software_recovery \
        #       --skip backend::spm::tests::test_inline_install_command_uses_install_environment \
        #       --skip cmd::tests::test_direct_inline_supervision \
        #       --skip inline_command::unix::tests::native_argv0_and_logical_pwd \
        #       --skip system::packages::brew::cask::tests::adopts_only_an_identical_existing_app \
        #       --skip system::packages::brew::cask::tests::auto_updates_reads_string_versions_from_xml_and_binary_plists \
        #       --skip system::packages::brew::cask::tests::ditto_into_rejects_preplanted_symlink_destination \
        #       --skip system::packages::brew::cask::tests::ensure_trusted_appdir_creates_missing_tail \
        #       --skip system::packages::brew::cask::tests::ensure_trusted_appdir_rejects_symlinked_tail \
        #       --skip system::packages::brew::cask::tests::ensure_trusted_appdir_stays_bound_after_same_uid_replacement \
        #       --skip system::packages::brew::cask::tests::ensure_trusted_appdir_walks_from_unreplaceable_root \
        #       --skip system::packages::brew::cask::tests::failed_app_activation_preserves_caskroom_copy \
        #       --skip system::packages::brew::cask::tests::self_updating_cask_adopts_a_different_existing_app
        #     '';
        #   }
        # );

        # globalConfig = {
        #   settings = {
        #     experimental = mkDefault true;
        #     verbose = mkDefault false;

        #     # prevent most supply chain attacks
        #     minimum_release_age = mkDefault "7d";

        #     # Aqua backend SecOps
        #     aqua = {
        #       cosign = mkDefault true; # Cosign checks (sigstore signatures)
        #       slsa = mkDefault true; # SLSA checks (builds provenance)
        #       github_attestations = mkDefault true; # GitHub Actions attestations
        #     };

        #     pipx.uvx = mkDefault true;
        #   };

        #   plugins = {
        #     nix = mkDefault "https://github.com/jbadeau/mise-nix";
        #     php = mkDefault "https://github.com/verzly/mise-php#latest";
        #     # fnox-env = mkDefault "https://github.com/jdx/mise-env-fnox";
        #   };

        #   env = {
        #     _ = {
        #       # fnox-env = {
        #       #   tools = mkDefault true;
        #       # };
        #       php = {
        #         pie_extensions = mkDefault "xdebug/xdebug";
        #       };
        #     };
        #   };
        #   # tools = {
        #   #   trivy = {
        #   #     # trivy updates are time-sensitive, use a shorter window
        #   #     minimum_release_age = mkDefault "1d";
        #   #   };
        #   # };
        # };
      };
    };
  };
}
