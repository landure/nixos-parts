/**
  # skhx

  Select file with skf, and open it with Helix editor (hx)

  ## 🙇 Acknowledgements

  - [Supercharging the shell @ On data, programming, and technology](https://ivergara.github.io/Supercharging-shell.html).
*/
{
  writeShellApplication,
  biapy-parts,
  gum,
  helix,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skf;
in
writeShellApplication {
  name = "skhx";
  runtimeInputs = [
    skf
    gum
    helix
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skhx.sh;
}
