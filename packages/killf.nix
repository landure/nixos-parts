/**
 # killf

 Fuzzy Kill Process.

 ## 🙇 Acknowledgements

 - [Use CLI like a modern tech bro @ Tsukie](https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/).
 */
{
  writeShellApplication,
  fzf,
  ps,
  uutils-coreutils,
  uutils-findutils,
  witr,
}:
writeShellApplication {
  name = "killf";
  runtimeInputs = [
    ps
    fzf
    uutils-coreutils
    uutils-findutils
    witr
  ];
  bashOptions = [
          "errexit"
          "nounset"
          "pipefail"
        ];
  text = ''
    # killf: Fuzzy Kill Process.
    # see https://www.tsukie.com/en/technologies/use-cli-like-a-modern-tech-bro/
    ps -ef |
    tail --lines +2 |
    fzf --with-nth=2,8.. --accept-nth=2 \
      --no-multi --header='Select process to kill' \
      --height=100% --layout=default --border --info=inline \
      --preview-window=right:40%:wrap \
      --preview='witr --pid {2}' |
    xargs kill -9
  '';
}
