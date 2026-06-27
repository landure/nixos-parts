/**
  # Home Manager Zsh

  ## 🛠️ Tech Stack

  - [Zsh homepage](https://www.zsh.org/).
  - [Zsh development homepage](https://zsh.sourceforge.io/).
  - [Zsh @ SourceForge](https://sourceforge.net/projects/zsh/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.zsh](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable).

  ## 🙇 Acknowledgements

  - [Unlimited history in zsh @ Stack Exchange](https://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.zsh;
in
{
  options = {
    biapy.programs.zsh = {
      enable = mkEnableOption "command-line UX enhancements";
    };
  };

  config = mkIf cfg.enable {

    programs.zsh = {
      enable = mkDefault true;
      enableVteIntegration = mkDefault true;
      autosuggestion.enable = mkDefault true;
      oh-my-zsh.enable = mkDefault true;

      sessionVariables = {
        HISTFILE = mkDefault "\${HOME}/.zsh_history";
        HISTSIZE = mkDefault 10000000;
        SAVEHIST = mkDefault 10000000;
      };

      setOptions = mkDefault [
        "BANG_HIST" # Treat the '!' character specially during expansion.
        "EXTENDED_HISTORY" # Write the history file in the ":start:elapsed;command" format.
        "INC_APPEND_HISTORY" # Write to the history file immediately, not when the shell exits.
        "SHARE_HISTORY" # Share history between all sessions.
        "HIST_EXPIRE_DUPS_FIRST" # Expire duplicate entries first when trimming history.
        "HIST_IGNORE_DUPS" # Don't record an entry that was just recorded again.
        "HIST_IGNORE_ALL_DUPS" # Delete old recorded entry if new entry is a duplicate.
        "HIST_FIND_NO_DUPS" # Do not display a line previously found.
        "HIST_IGNORE_SPACE" # Don't record an entry starting with a space.
        "HIST_SAVE_NO_DUPS" # Don't write duplicate entries in the history file.
        "HIST_REDUCE_BLANKS" # Remove superfluous blanks before recording entry.
        "HIST_VERIFY" # Don't execute immediately upon history expansion.
        "HIST_BEEP" # Beep when accessing nonexistent history.
      ];
    };
  };

}
