/**
  # skode

  Select file with skf, and open it with Visual Studio Code (code)

  ## 🙇 Acknowledgements

  - [Supercharging the shell @ On data, programming, and technology](https://ivergara.github.io/Supercharging-shell.html).
*/
{
  writeShellApplication,
  lib,
  biapy-parts,
  gum,
  vscode,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skf;
in
writeShellApplication {
  name = "skode";
  meta = {
    license = lib.licenses.cc-by-nc-sa-40;
  };
  runtimeInputs = [
    gum
    skf
    vscode
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skode.sh;
}
