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
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.bash;

  homeManagerSessionVars = "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
in
{
  options = {
    biapy.programs.bash.enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
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
