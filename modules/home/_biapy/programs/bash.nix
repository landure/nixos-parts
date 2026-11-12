/**
  # Bash shell

  ## 🛠️ Tech Stack

  - [Bash homepage](https://www.gnu.org/software/bash/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.bash @ NixOS reference](https://search.nixos.org/options?query=programs.bash&source=home_manager).
  - [programs.bash @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enable).
  - [home.shell.enableBashIntegration @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableBashIntegration).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool;

  cfg = config.biapy.programs.bash;

  homeManagerSessionVars = "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
in
{
  options.biapy.programs.bash = {
    enable = mkEnableOption "bash";

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install bash-pro, bash-linux, bash-defensive-patterns, and bash-scripting agent skills.";
    };
  };

  config = mkIf cfg.enable {
    biapy.ai.skills.skills = mkIf cfg.withSkill {
      bash-pro = mkDefault (pkgs.biapy-parts.agentic-awesome-skills + "/skills/bash-pro");
      bash-linux = mkDefault (pkgs.biapy-parts.agentic-awesome-skills + "/skills/bash-linux");
      bash-defensive-patterns = mkDefault (
        pkgs.biapy-parts.agentic-awesome-skills + "/skills/bash-defensive-patterns"
      );
    };

    programs = {
      bash = {
        enable = mkDefault true;
        enableCompletion = mkDefault true;
        enableVteIntegration = mkDefault true;
        # bashrcExtra = mkDefault ''
        #   # Load "''${HOME}/.config/bash/bashrc.bash"
        #   [[ -e "''${XDG_CONFIG_HOME:-"''${HOME}/.config"}/bash/bashrc.bash" ]] &&
        #     source "''${XDG_CONFIG_HOME:-"''${HOME}/.config"}/bash/bashrc.bash"
        # '';

        initExtra = mkDefault ''
          [[ -f "${homeManagerSessionVars}" ]] && source "${homeManagerSessionVars}"
        '';
      };
    };
  };
}
