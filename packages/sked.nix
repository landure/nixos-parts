/**
  # sked

  Select file with skf, and open it with $VISUAL, $EDITOR, or nano

  ## 🙇 Acknowledgements

  - [Supercharging the shell @ On data, programming, and technology](https://ivergara.github.io/Supercharging-shell.html).
*/
{
  writeShellApplication,
  biapy-parts,
  gum,
  nano,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skf;
in
writeShellApplication {
  name = "sked";
  runtimeInputs = [
    skf
    gum
    nano
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/sked.sh;
}
