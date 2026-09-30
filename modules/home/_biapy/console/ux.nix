/**
  # command-line UX enhancements

  ## 🛠️ Tech Stack

  - [gawk homepage](https://www.gnu.org/software/gawk/)
    handles simple data-reformatting jobs with just a few lines of code.
  - [gum @ GitHub](https://github.com/charmbracelet/gum)
    is a tool for glamorous shell scripts.
  - [sd - search & displace @ GitHub](https://github.com/chmln/sd)
    is an intuitive find & replace CLI (`sed` alternative).

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
  inherit (lib.meta) getExe;
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
    };

    services.ssh-agent.enable = mkDefault true;

    home.packages = with pkgs; [
      gawk
      gum
      sd
      biapy-parts.killf
    ];

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
