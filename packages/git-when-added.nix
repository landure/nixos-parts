/**
  # git-when-added

  Find the commits in which a given path was added.

  ## 🙇 Acknowledgements

  - [How can I find the commit in which a given file was added? @ Stack Overflow](https://stackoverflow.com/questions/11533199/how-can-i-find-the-commit-in-which-a-given-file-was-added).
*/
{
  writeShellApplication,
  bat,
  gum,
  skim,
}:
writeShellApplication {
  name = "git-when-added";
  runtimeInputs = [
    bat
    gum
    skim
  ];
  bashOptions = [
    "errexit"
    "nounset"
    "pipefail"
  ];
  text = ''
    usage() {
      echo "''${0}"
      echo ""
      echo "Find the commits in which a given path was added,"
      echo "allow to select a commit, and output the commit hash."
      echo ""
      echo "Usage: ''${0} <path>"
    }

    if ! command -v 'git' &>'/dev/null'; then
      gum log --level=error "git is not installed or not in PATH."
      exit 1
    fi

    if [[ "''${1}" == "-h" || "''${1}" == "-?" || "''${1}" == "--help" ]]; then
      usage
      exit 0
    fi

    if [[ $# -ne 1 ]]; then
      gum log --level=error "exactly 1 argument required."
      usage
      exit 1
    fi

    # Find the commit in which a given file was added.
    git log --diff-filter=A --find-renames=40% --follow --reverse --color=always \
        --pretty=format:'%H %Cgreen%ci%Creset %C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' \
        -- "''${1}" |
    sk --with-nth='2..' --ansi --height='100%' --output-format='{1}' \
        --preview='git show --summary {1} | bat --plain --color=always'
  '';
}
