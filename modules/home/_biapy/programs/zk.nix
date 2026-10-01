/**
  # zk

  zk is a command-line tool helping you to maintain a plain text Zettelkasten
  or personal wiki.

  ## 🛠️ Tech Stack

  - [zk homepage](https://zk-org.github.io/zk/)
    ([zk @ GitHub](https://github.com/zk-org/zk)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.zk @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zk.enable).
  - [programs.zk @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.zk.).

  ## 🙇 Acknowledgements

  - [Ep 91: Old man hands @ Linux Matters](https://linuxmatters.sh/91/).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.biapy.programs.zk;
in
{
  options.biapy.programs.zk = {
    enable = mkEnableOption "zk";

    author = mkOption {
      type = str;
      default = config.biapy.user.identity.fullname;
      description = "Default author for new notes";
    };

    notebookDir = mkOption {
      type = str;
      default = "$HOME/zettelkasten";
      description = "Path to the zk notebook directory";
    };
  };

  config = mkIf cfg.enable {
    biapy.programs.bat.enable = mkDefault true;

    home = {
      sessionVariables.ZK_NOTEBOOK_DIR = mkDefault "${cfg.notebookDir}";

      shellAliases = {
        daily = mkDefault "zk daily";
        note = mkDefault "zk note";
        pastanote = mkDefault "wl-paste | zk new --interactive";
      };
    };

    xdg.configFile."zk/templates/default.md".text = mkDefault ''
      ---
      id: {{id}}
      date: {{format-date now}} {{format-date now "time"}}
      modified: {{format-date now}} {{format-date now "time"}}
      keywords: []
      ---
      # {{title}}

      Written by {{extra.author}}.

      {{content}}
    '';

    xdg.configFile."zk/templates/daily.md".text = mkDefault ''
      ---
      id: {{id}}
      date: {{format-date now}} {{format-date now "time"}}
      modified: {{format-date now}} {{format-date now "time"}}
      keywords:
        - daily
        - {{format-date now '%Y-%m'}}
      ---
      # {{format-date now "long"}}

      Written by {{extra.author}}.

      Today, I …

      {{content}}
    '';

    programs.zk = {
      enable = mkDefault true;
      # exportNotebookDir = mkDefault true;
      settings = {
        extra = {
          visibility = "public";
          author = mkDefault cfg.author;
        };
        notebook.dir = mkDefault cfg.notebookDir;

        note = {
          language = mkDefault "en";
          filename = mkDefault "{{id}}-{{slug title}}";
          id-case = mkDefault "lower";
          id-length = mkDefault 7;
          id-charset = mkDefault "hex";
        };

        format.markdown = {
          hashtags = mkDefault true;
          colon-tags = mkDefault true;
          multiword-tags = mkDefault true;
        };

        group = {
          journal = {
            # Apply to child directories of "journal".
            paths = mkDefault [
              "journal"
            ];

            extra = {
              visibility = mkDefault "private";
            };
          };
          daily = {
            paths = mkDefault [ "journal/daily" ];
            extra = {
              visibility = mkDefault "private";
            };
            note = {
              filename = mkDefault "{{format-date now '%Y-%m-%d'}}";
              extension = mkDefault "md";
              template = mkDefault "daily.md";
            };
          };
        };

        tool = {
          fzf-line = mkDefault "{{style 'blue' rel-path}}{{#each tags}} #{{this}}{{/each}} {{style 'black' body}}";
          fzf-preview = mkDefault "bat --plain --color=always {-1}";
          # fzf-preview = mkDefault "zk list --quiet --format full --limit 1 {-1}";
          fzf-bind-new = mkDefault "Ctrl-N";
        };

        # NAMED FILTERS
        filter = {
          recents = mkDefault "--sort created- --created-after 'last two weeks'";
          journal = mkDefault "--sort created journal";
        };

        # COMMAND ALIASES
        alias = {
          # Shortcuts for native commands
          ls = mkDefault "zk list \"\${@}\"";
          ed = mkDefault "zk edit \"\${@}\"";
          n = mkDefault "zk new \"\${@}\"";

          # Edit the configuration file
          conf = mkDefault ''''${EDITOR} "''${ZK_NOTEBOOK_DIR}/.zk/config.toml"'';

          # List paths in a command-line friendly fashion
          paths = mkDefault "zk list --quiet --format \"'{{path}}'\" --delimiter ' ' \"\${@}\"";

          # List paths to be used in a parent zk command
          inline = mkDefault "zk list --quiet --format '{{path}}' --delimiter ',' \"\${@}\"";

          daily = mkDefault "zk new --no-input \"\${ZK_NOTEBOOK_DIR}/journal/daily\"";
          journal = mkDefault "zk new \"\${ZK_NOTEBOOK_DIR}/journal\"";
          note = mkDefault "zk edit --interactive \"\${@}\"";
          pastanote = mkDefault "wl-paste | zk new --interactive \"\${@}\"";

          # Create a note from a free title
          nt = mkDefault "zk new --title \"$*\"";
          ntc = mkDefault "zk new --print-path --title \"$*\" | wl-copy";

          # Print and sort the word count of selected notes
          wc = mkDefault "zk list --format '{{word-count}}\t{{title}}' --sort word-count \"\${@}\"";

          # Print the backlinks of a note
          bl = mkDefault "zk list --link-to \"\${@}\"";
          # Fix missing backlinks interactively
          fix-backlinks = mkDefault "zk edit --interactive --missing-backlink";
          unlinked-mentions = mkDefault "zk list --mentioned-by \"$1\" --no-linked-by \"$1\"";
          log = mkDefault "zk list --quiet --format path --delimiter0 \"\${@}\" | xargs -0 git log --patch --";
          save = mkDefault "git add . && git commit -m \"$*\"";
          regexlist = mkDefault "zk list --match-strategy re \"\${@}\"";
          # Edit the last modified note.
          edlast = mkDefault "zk edit --limit 1 --sort modified- \"\${@}\"";
          # Edit the notes selected interactively among the notes created the last two weeks.
          recent = mkDefault "zk edit --sort created- --created-after 'last two weeks' --interactive";
          # Show a random note.
          lucky = mkDefault "zk list --quiet --format full --sort random --limit 1";
        };

        lsp = {
          diagnostics = {
            # Report titles of wiki-links as hints.
            wiki-title = mkDefault "hint";
            # Warn for dead links between notes.
            dead-link = mkDefault "error";
            # Warn when a note links to itself.
            self-link = mkDefault "warning";
            # Warn when notes link here without backlinks.
            missing-backlink = {
              level = mkDefault "warning";
              position = mkDefault "bottom";
            };
          };
          completion = {
            # Show the note title in the completion pop-up, or fallback on its path if empty.
            note-label = mkDefault "{{title-or-path}}";
            # Only suggest notes matching the given filtering options.
            note-filter = mkDefault "--tag project --sort modified-";
            # Filter out the completion pop-up using the note title or its path.
            note-filter-text = mkDefault "{{title}} {{path}}";
            # Show the note filename without extension as detail.
            note-detail = mkDefault "{{filename-stem}}";
          };
        };
      };
    };
  };
}
