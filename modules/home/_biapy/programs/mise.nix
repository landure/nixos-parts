/**
  # mise-en-place

  `mise` is a development environment manager.

  ## 🛠️ Tech Stack

  - ([mise-en-place homepage](https://mise.jdx.dev/))
    ([mise @ GitHub](https://github.com/jdx/mise)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.mise](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.enable).

  ## 🙇 Acknowledgements

  - [La veille des Ours n°31 @ Bearstech's LinkedIn :fr:](https://www.linkedin.com/pulse/la-veille-des-ours-n31-bearstech-gbmgf/).
  - [Adieu `direnv`, Bonjour `mise` @ Julien Wittouck](https://codeka.io/2025/12/19/adieu-direnv-bonjour-mise/).
  - [Mon environnement de développement avec mise et chez-moi @ À l'encre rouillée :fr:](https://david.drugeon-hamon.bzh/blog/2026/02/env-dev-avec-mise-et-chezmoi/).
  - [Mise-en-place & Fnox : mon setup de gestion multi-projets @ Rémi Tech Notes :fr:](https://www.vrchr.fr/posts/2026/04/28/mise-en-place-fnox-setup-multi-projets/).
  - [Mise + Krew : vos plugins kubectl en mode déclaratif @ Une Tasse de Café :fr:](https://une-tasse-de.cafe/expresso/mise-krew/).
  - [Mise : un multi-outil pour votre poste de Dev & Ops @ Devoxx France's YouTube :fr:](https://www.youtube.com/watch?v=ZEtc6WnreI0).
*/
{
  config,
  lib,
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
    programs = {
      mise = {
        enable = mkDefault true;

        globalConfig = {
          settings = {
            experimental = mkDefault true;
            verbose = mkDefault false;
          };

          plugins = {
            nix = mkDefault "https://github.com/jbadeau/mise-nix";
            fnox-env = mkDefault "https://github.com/jdx/mise-env-fnox";
          };
        };
      };
    };
  };
}
