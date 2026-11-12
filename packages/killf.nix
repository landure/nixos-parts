/**
  # killf

  Fuzzy Kill Process.

  ## 🙇 Acknowledgements

  - [Use CLI like a modern tech bro @ Tsukie](https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/).
*/
{
  writeShellApplication,
  fzf,
  gum,
  ps,
  uutils-coreutils-noprefix,
  uutils-findutils,
  witr,
}:
writeShellApplication {
  name = "killf";
  runtimeInputs = [
    ps
    fzf
    gum
    uutils-coreutils-noprefix
    uutils-findutils
    witr
  ];
  bashOptions = [
    "errexit"
    "nounset"
    "pipefail"
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/killf.sh;
}
