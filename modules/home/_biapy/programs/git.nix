/**
  # Git

  Git is a free and open source distributed version control system designed
  to handle everything from small to very large projects with speed
  and efficiency.

  ## 🛠️ Tech Stack

  - [Git homepage](https://git-scm.com/).
  - [Git worktree switcher ⚡ @ GitHub](https://github.com/yankeexe/git-worktree-switcher).
  - [git-credential-keepassxc @ GitHub](https://github.com/frederick888/git-credential-keepassxc).
  - [git-credential-oauth @ GitHub](https://github.com/hickford/git-credential-oauth).

  ## 📝 Documentation

  - [programs.git @ NixOS reference](https://search.nixos.org/options?query=programs.git).

  ### 🏠 Home Manager Configuration Options

  - [programs.git](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable).

  ### 🎨 Stylix

  - [GitUI @ Stylix](https://nix-community.github.io/stylix/options/modules/gitui.html).
  - [LazyGit @ Stylix](https://nix-community.github.io/stylix/options/modules/lazygit.html).

  ## 🙇 Acknowledgements

  - [Git @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Git).
  - [Git @ NixOS Wiki](https://nixos.wiki/wiki/Git).
  - [A Collection of Useful .gitattributes Templates @ GitHub](https://github.com/gitattributes/gitattributes).
  - [Archiving git branches as tags @ et cetera](https://etc.octavore.com/2025/12/archiving-git-branches-as-tags/).
  - [How to Customize Git Help for Your Aliases in NixOS @ PUPUWEB](https://pupuweb.com/how-customize-git-help-aliases-nixos/).
  - [What is the cleanest way to add Git Alias project to Home manager config? @ r/NixOS](https://www.reddit.com/r/NixOS/comments/rtj5h2/what_is_the_cleanest_way_to_add_git_alias_project/).
  - [Git Rebase @ Alchemists](https://alchemists.io/articles/git_rebase).
  - [Git: Improve diff generation with diff.algorithm=histogram @ Adam Johnson](https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/).
  - [How Core Git Developers Configure Git @ GitButler](https://blog.gitbutler.com/how-git-core-devs-configure-git/).
  - [Git Rebase AutoSquash @ Alchemists](https://alchemists.io/articles/git_rebase_autosquash).
  - [A Trick To Use mkMerge at The Top Level of a NixOS module @ Samara's GitHub Gist](https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43).
  - [Git Worktree Comme Un Chef @ Metal3d 🇫🇷](https://www.metal3d.org/blog/2026/git-worktree-comme-un-chef/).
  - [The Git Commands I Run Before Reading Any Code @ Ally Piechowski](https://piechowski.io/post/git-commands-before-reading-code/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkDefault mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.git;

in
{
  options.biapy.programs.git.enable = mkEnableOption "Git";

  config = mkIf cfg.enable {
    home.shellAliases = {
      g = mkDefault "git";
      gco = mkDefault "git commit";
    };

    programs = {
      ssh.settings = {
        "gitlab.com" = {
          user = mkDefault "git";
          PreferredAuthentications = mkDefault "publickey";
        };

        "github.com" = {
          user = mkDefault "git";
          PreferredAuthentications = mkDefault "publickey";
        };
      };

      git = {
        enable = mkDefault true;

        # Use a git version with SSH support (eg: pkgs.gitFull).
        package = mkDefault pkgs.gitFull;

        signing = {
          format = mkDefault "ssh";
          key = mkDefault config.sops.secrets."ssh/identities/id_ed25519/private_key".path or null;
          signByDefault = mkDefault true;
        };

        settings = {
          # See
          signing.signer =
            let
              defaultSigners = {
                openpgp = getExe config.programs.gpg.package;
                ssh =
                  if config.programs.ssh.enable then
                    if config.programs.ssh.package != null then
                      getExe' config.programs.ssh.package "ssh-keygen"
                    else
                      "ssh-keygen"
                  else
                    getExe' pkgs.openssh "ssh-keygen";
                x509 = getExe' config.programs.gpg.package "gpgsm";
              };
            in
            mkIf (config.programs.git.signing.format != null) (
              mkOptionDefault defaultSigners.${config.programs.git.signing.format}
            );

          url = {
            "git@github.com:".insteadOf = mkDefault "https://github.com/";
            "git@gitlab.com:".insteadOf = mkDefault "https://gitlab.com/";
          };

          # Set main as the initial default branch name for new repositories
          init.defaultBranch = mkDefault "main";

          # Sort `git branch` output by commit date rather by name.
          branch.sort = mkDefault "committerdate";

          push = {
            # Automatically create remote branch on push.
            autosetupremote = mkDefault true;

            # Automatically push annotated tags pointing to commits reachable
            # from the pushed refs:
            followTags = mkDefault true;

            # Force the push if the local branch integrates the tip of the
            # remote-tracking ref:
            useForceIfIncludes = mkDefault true;

            # Configure git to push the current branch with the same name
            # on the remote
            default = mkDefault "simple";
          };

          # Use `histogram` as `git diff` algorithm for better readability.
          diff.algorithm = mkDefault "histogram";

          core = {
            # Enable file changes watching and caching to quicken commands
            # such as `git status`
            fsmonitor = mkDefault true;
            untrackedcache = mkDefault true;
          };

          # Enable rebasing by default on pull requests.
          pull.rebase = mkDefault true;

          rebase = {
            # Use abbreviated command names in the todo list (`p` for `pick`, …)
            abbreviateCommands = mkDefault false;

            # Use auto-squashing by default when rebasing interactively.
            autoSquash = mkDefault true;

            # Automatically stash uncommitted changes before rebasing.
            autoStash = mkDefault true;

            # Automatically force-update any branches that point to rebased commits
            updateRefs = mkDefault true;
          };

          # Enable REusing REcorded REsolution on conflicted merges:
          rerere = {
            enabled = mkDefault true;
            autoUpdate = mkDefault true;
          };

          # Enable automatic pruning of all unreachable objects from the
          # object database.
          core = {
            prune = mkDefault true;
            pruneexpire = mkDefault "2.weeks.ago";
          };

          credential.helper = mkDefault [
            # git-credential-oauth
            "cache --timeout 21600" # 6 hours
            "oauth"

            # git-credential-keepassxc
            # "keepassxc --git-groups"
          ];

          http.postBuffer = mkDefault 524288000;

          alias = {
            co = mkDefault "checkout";
            unstage = mkDefault "reset HEAD"; # remove all files from staging
            uncommit = mkDefault "update-ref HEAD HEAD^"; # undo last commit
            uncommithard = mkDefault "reset --hard HEAD^"; # undo last commit and its change, if not pushed to origin.
            oups = mkDefault "commit -a --amend -C HEAD"; # add all changes to last commit
            amend = mkDefault "commit --amend --no-edit"; # amend last commit
            undomerge = mkDefault "reset --hard ORIG_HEAD"; # undo last merge, if not pushed to origin
            # display enhanced `git` logs:
            lg = mkDefault "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
            logfull = mkDefault "log --pretty=fuller --graph --stat -p"; # display full git logs
            pickaxe = mkDefault "log -S"; # give you all commits that added or removed a string in a codebase.

            # archive git branch as tag
            # @see https://etc.octavore.com/2025/12/archiving-git-branches-as-tags/
            archive-branch = mkDefault ''
              !f() { \
                : git switch; \
                local git_branch=''${1:-''$(git branch --show-current)}; \
                git checkout 'main' && \
                  git tag "archive/''${git_branch}" "''${git_branch}" && \
                  git branch -D "''${git_branch}"; \
              }; f
            '';
          };
        };

        # Git attributes set globally
        # @see https://github.com/gitattributes/gitattributes
        attributes = mkDefault [
          # Auto detect text files and perform LF normalization
          "*          text=auto"

          #
          # The above will handle all files NOT found below
          #

          # Documents
          "*.bibtex   text diff=bibtex"
          "*.doc      diff=astextplain"
          "*.DOC      diff=astextplain"
          "*.docx     diff=astextplain"
          "*.DOCX     diff=astextplain"
          "*.dot      diff=astextplain"
          "*.DOT      diff=astextplain"
          "*.pdf      diff=pdf"
          "*.PDF      diff=pdf"
          "*.rtf      diff=astextplain"
          "*.RTF      diff=astextplain"
          "*.md       text diff=markdown"
          "*.mdx      text diff=markdown"
          "*.tex      text diff=tex"
          "*.adoc     text"
          "*.textile  text"
          "*.mustache text"
          "*.csv      text eol=crlf"
          "*.tab      text"
          "*.tsv      text"
          "*.txt      text"
          "*.sql      text"
          "*.epub     diff=astextplain"

          # Graphics
          "*.png      binary"
          "*.jpg      binary"
          "*.jpeg     binary"
          "*.gif      binary"
          "*.tif      binary"
          "*.tiff     binary"
          "*.ico      binary"
          # SVG treated as text by default.
          "*.svg      text"
          # If you want to treat it as binary,
          # use the following line instead.
          # "*.svg    binary"
          "*.eps      binary"

          # Scripts
          "*.bash     text eol=lf"
          "*.fish     text eol=lf"
          "*.ksh      text eol=lf"
          "*.sh       text eol=lf"
          "*.zsh      text eol=lf"
          # These are explicitly windows files and should use crlf
          "*.bat      text eol=crlf"
          "*.cmd      text eol=crlf"
          "*.ps1      text eol=crlf"

          # Serialisation
          "*.json     text"
          "*.toml     text"
          "*.xml      text"
          "*.yaml     text"
          "*.yml      text"

          # Archives
          "*.7z       binary"
          "*.bz       binary"
          "*.bz2      binary"
          "*.bzip2    binary"
          "*.gz       binary"
          "*.lz       binary"
          "*.lzma     binary"
          "*.rar      binary"
          "*.tar      binary"
          "*.taz      binary"
          "*.tbz      binary"
          "*.tbz2     binary"
          "*.tgz      binary"
          "*.tlz      binary"
          "*.txz      binary"
          "*.xz       binary"
          "*.Z        binary"
          "*.zip      binary"
          "*.zst      binary"

          # Text files where line endings should be preserved
          "*.patch    -text"

          #
          # Exclude files from exporting
          #
          ".gitattributes export-ignore"
          ".gitignore     export-ignore"
          ".gitkeep       export-ignore"

        ];

        # List of paths that should be globally ignored.
        ignores = mkDefault [
          "*~"
          "*.swp"
        ];
      };
    };
  };
}
