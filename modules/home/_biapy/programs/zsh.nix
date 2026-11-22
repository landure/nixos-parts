/**
  # Home Manager Zsh

  ## 🛠️ Tech Stack

  - [Zsh homepage](https://www.zsh.org/).
  - [Zsh development homepage](https://zsh.sourceforge.io/).
  - [Zsh @ SourceForge](https://sourceforge.net/projects/zsh/).

  ### 💼 Plugin managers

  - [antidote homepage](https://antidote.sh/)
    ([antidote @ GitHub](https://github.com/mattmc3/antidote))
     is a Zsh plugin manager made from the ground up thinking about performance.
  - [Oh My Zsh homepage](https://ohmyz.sh/)
    ([Oh My Zsh @ GitHub](https://github.com/ohmyzsh/ohmyzsh))
    is an open source, community-driven framework for managing your zsh configuration.

  ### 🧩 Plugins

  - [zsh-history-substring-search @ GitHub](https://github.com/zsh-users/zsh-history-substring-search)
    is a clean-room implementation of the Fish shell's history search feature,
    where you can type in any part of any command from history
    and then press chosen keys, such as the UP and DOWN arrows,
    to cycle through matches.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.zsh @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/zsh.html).
  - [programs.zsh @ NixOS reference](https://search.nixos.org/options?query=programs.zsh&source=home_manager).

  ## 🙇 Acknowledgements

  - [Zsh @ NixOS Official Wiki](https://wiki.nixos.org/wiki/Zsh).
  - [Unlimited history in zsh @ Stack Exchange](https://unix.stackexchange.com/a/273863).
  - [How do I use Oh-My-Zsh with antidote? #70 @ antidote's GitHub](https://github.com/mattmc3/antidote/discussions/70).
  - [Aliases @ Mastering ZSH's GitHub](https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/aliases.md).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkAfter mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.zsh;
in
{
  options.biapy.programs.zsh.enable = mkEnableOption "zsh";

  config = mkIf cfg.enable {

    programs.zsh = {
      enable = mkDefault true;

      dotDir = mkDefault "${config.xdg.configHome}/zsh";

      enableCompletion = mkDefault true;
      enableVteIntegration = mkDefault true;
      autosuggestion.enable = mkDefault true;
      syntaxHighlighting.enable = mkDefault true;
      oh-my-zsh.enable = mkDefault true;

      shellAliases = {
        ss = mkDefault "sudo ";
        ":q" = mkDefault "exit";
        ".." = mkDefault "cd ..";
        "..." = mkDefault "cd ../..";
        "-" = mkDefault "cd -";

        # Search through your command history and print the top 10 commands
        history-stat = mkDefault "history 0 | awk '{print $2}' | sort | uniq --count | sort --numeric-sort --reverse | head";
      };

      initContent = mkAfter ''
        # pipe output to grep
        alias -g G='| rg'
        # pipe output to less
        alias -g L='| bat --plain'
        # pipe output to `wc` with option `-l`
        alias -g W='| wc --lines'
        # convert multiline output to single line and copy it to the system clipboard
        alias -g C="| tr --delimiter='\n' | wl-copy --primary --regular"
      '';

      history = {
        size = mkDefault 10000000;
        save = mkDefault 10000000;
        append = mkDefault true;
        extended = mkDefault true; # Write the history file in the ":start:elapsed;command" format.
        share = mkDefault true; # Share history between all sessions.
        expireDuplicatesFirst = mkDefault true; # Expire duplicate entries first when trimming history.
        findNoDups = mkDefault true; # Do not display a line previously found.
        ignoreDups = mkDefault true; # Don't record an entry that was just recorded again.
        ignoreAllDups = mkDefault true; # Delete old recorded entry if new entry is a duplicate.
        ignoreSpace = mkDefault true; # Don't record an entry starting with a space.
        saveNoDups = mkDefault true; # Don't write duplicate entries in the history file.
        # reduceBlanks = mkDefault true; # Remove superfluous blanks before recording entry.
        # verify = mkDefault true; # Don't execute immediately upon history expansion.
        path = mkDefault "\${HOME}/.zsh_history";
        ignorePatterns = mkDefault [
          "rm *"
          "pkill *"
          "cp *"
        ];
      };

      historySubstringSearch.enable = mkDefault true;

      setOptions = mkDefault [
        "BANG_HIST" # Treat the '!' character specially during expansion.
        "INC_APPEND_HISTORY" # Write to the history file immediately, not when the shell exits.
        "HIST_REDUCE_BLANKS" # Remove superfluous blanks before recording entry.
        "HIST_VERIFY" # Don't execute immediately upon history expansion.
        "HIST_BEEP" # Beep when accessing nonexistent history.
      ];
    };
  };

}
