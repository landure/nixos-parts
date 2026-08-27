/**
  # Git

  Git is a free and open source distributed version control system designed
  to handle everything from small to very large projects with speed
  and efficiency.

  ## 🛠️ Tech Stack

  - [Git homepage](https://git-scm.com/).

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
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.programs.git-utils;

in
{
  options.biapy.programs.git-utils.enable = mkEnableOption "Git utilities";

  config = mkIf cfg.enable {
    biapy.programs.git.enable = mkDefault true;
    home.packages = with pkgs; [
      # Prune or list local tracking branches that do not exist on remote anymore.
      # https://stackoverflow.com/questions/13064613/how-to-prune-local-tracking-branches-that-do-not-exist-on-remote-anymore/17029936#17029936
      (writeShellScriptBin "git-list-untracked" ''
        git fetch --prune &&
          git branch -r |
          awk "{print \$1}" |
          grep -E -v -f '/dev/fd/0' <(git branch -vv | grep origin) |
          awk "{print \$1}"
      '')
      (writeShellScriptBin "git-remove-untracked" ''
        git fetch --prune &&
          git branch -r |
          awk "{print \$1}" |
          grep -E -v -f '/dev/fd/0' <(git branch -vv | grep origin) |
          awk "{print \$1}" |
          xargs git branch -d
      '')
      (writeShellScriptBin "git-remove-untracked-force-unmerged" ''
        git fetch --prune &&
          git branch -r |
          awk "{print \$1}" |
          grep -E -v -f '/dev/fd/0' <(git branch -vv | grep origin) |
          awk "{print \$1}" |
          xargs git branch -D
      '')
      (writeShellScriptBin "git-most-changed" ''
        # # What Changes the Most
        #
        # The 20 most-changed files in the last year.
        # The file at the top is almost always the one people warn me about.
        # “Oh yeah, that file. Everyone’s afraid to touch it.”
        #
        # see https://piechowski.io/post/git-commands-before-reading-code/
        git log --format='format:' --name-only --since='1 year ago' |
        sort |
        uniq -c |
        sort -nr |
        head -20
      '')
      (writeShellScriptBin "git-list-contributors" ''
        # # Who Built This
        #
        # Every contributor ranked by commit count.
        # If one person accounts for 60% or more, that’s your bus factor.
        #
        # see https://piechowski.io/post/git-commands-before-reading-code/
        git shortlog -sn --no-merges
      '')
      (writeShellScriptBin "git-bugs" ''
        # # Where Do Bugs Cluster
        #
        # Same shape as the churn command, filtered to commits with bug-related keywords.
        # Compare this list against the churn hotspots.
        # Files that appear on both are your highest-risk code:
        # they keep breaking and keep getting patched, but never get properly fixed.
        #
        # see https://piechowski.io/post/git-commands-before-reading-code/
        git log -i -E --grep='fix|bug|broken' --name-only --format="" |
          sort |
          uniq -c |
          sort -nr |
          head -20
      '')
      (writeShellScriptBin "git-speeddial" ''
        # # Is This Project Accelerating or Dying
        #
        # Commit count by month, for the entire history of the repo.
        # This is team data, not code data.
        #
        # see https://piechowski.io/post/git-commands-before-reading-code/
        git log --format='%ad' --date=format:'%Y-%m' |
          sort |
          uniq -c
      '')
      (writeShellScriptBin "git-firefights" ''
        # # How Often Is the Team Firefighting
        #
        # Revert and hotfix frequency. A handful over a year is normal.
        # Reverts every couple of weeks means the team doesn’t trust its deploy process.
        #
        # see https://piechowski.io/post/git-commands-before-reading-code/
        git log --oneline --since="1 year ago" |
          grep -iE 'revert|hotfix|emergency|rollback'
      '')

      # https://www.metal3d.org/blog/2026/git-worktree-comme-un-chef/
      (writeShellScriptBin "wtree" ''
        # Usage: wtree <git url> (dans un dossier vide)
        REPO_URL="''${1}"
        SCRIPT_NAME=$(basename "''${0}")

        if [ -z "''${REPO_URL}" ]; then
          echo "❌ Erreur : URL du dépôt manquante."
          echo "Usage: $0 <repo-url>"
          exit 1
        fi

        # 1. Vérifier si le dossier courant est vide
        # On autorise la présence du script lui-même
        FILES_IN_DIR="$(ls -A | grep -v "''${SCRIPT_NAME}")"
        if [ ! -z "''${FILES_IN_DIR}" ]; then
          echo "❌ Erreur : Le dossier courant n'est pas vide !"
          echo "Pour garder votre configuration worktree propre, merci de lancer ceci dans un dossier frais."
          exit 1
        fi

        echo "🚀 Initialisation du setup Pro Git Worktree..."

        # 2. Cloner en bare dans un dossier caché
        git clone --bare "''${REPO_URL}" .bare

        # 3. Lier la racine au dépôt bare
        echo "gitdir: ./.bare" > .git

        # 4. Activer le remote tracking (Le fix "Remote Awareness")
        # Cela assure que 'git fetch' voit toutes les branches du serveur
        git config 'remote.origin.fetch' "+refs/heads/*:refs/remotes/origin/*"

        # 5. Tout fetcher
        git fetch --all

        echo "✅ Setup terminé !"
        echo "Prochaine étape : git worktree add main"
      '')
    ];
  };
}
