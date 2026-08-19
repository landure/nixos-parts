/**
  # command-line UX enhancements

  ## 🛠️ Tech Stack

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [home.shell](https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableBashIntegration).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.console.ux;
in
{
  options = {
    biapy.console.ux = {
      enable = mkEnableOption "command-line UX enhancements";
    };
  };

  config = mkIf cfg.enable {

    home.file = {
      ".local/bin/p" = {
        enable = mkDefault true;
        executable = mkDefault true;
        text = mkDefault ''
          #!/usr/bin/env bash
          # p: fzf + bat Preview (File Browser Mode).
          # Scroll files and see live syntax-highlighted previews.
          # Usage: `fd | p`
          # see https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/
          set -e
          set -u
          set -o pipefail

          exec ${getExe config.programs.fzf.package} --preview "${getExe config.programs.bat.package} --color=always --style=numbers --line-range=':500' {}"
        '';
      };

      ".local/bin/v" = {
        enable = mkDefault true;
        executable = mkDefault true;
        text = mkDefault ''
          #!/usr/bin/env bash
          # v: fd + fzf + bat Fuzzy Open File with Preview.
          # Scroll files and see live syntax-highlighted previews.
          # Accepts fd arguments.
          # Usage: `v -IH './vendor'`
          # see https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/
          set -e
          set -u
          set -o pipefail

          ${getExe config.programs.fd.package} --type 'f' "''${@}" |
          ${getExe config.programs.fzf.package} --preview "${getExe config.programs.bat.package} --color='always' --style='numbers' {}"
        '';
      };

      ".local/bin/killf" = {
        enable = mkDefault true;
        executable = mkDefault true;
        text = mkDefault ''
          #!/usr/bin/env bash
          # killf: Fuzzy Kill Process.
          # see https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/
          set -e
          set -u
          set -o pipefail

          ps -ef |
          ${getExe config.programs.fzf.package} --header "Select process to kill" |
          ${getExe pkgs.gawk} '{print ''$2}' |
          ${getExe' pkgs.uutils-findutils "xargs"} ${getExe' pkgs.uutils-coreutils-noprefix "kill"} -9
        '';
      };
    };

    services.ssh-agent.enable = mkDefault true;

    biapy.programs = {
      bash.enable = mkDefault true;
      bat.enable = mkDefault true;
      eza.enable = mkDefault true;
      fastfetch.enable = mkDefault true;
      flyline.enable = mkDefault true;
      fzf.enable = mkDefault true;
      mcfly.enable = mkDefault true;
      mise.enable = mkDefault true;
      pay-respects.enable = mkDefault true;
      skim.enable = mkDefault true; # `sk` Fuzzy Finder in rust!
      starship.enable = mkDefault true;
      # tirith.enable = mkDefault true; # disable since tirith 0.3.x doesn't support symlinks config files
      zellij.enable = mkDefault true;
      zsh.enable = mkDefault true;
    };
  };
}
