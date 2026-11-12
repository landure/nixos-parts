/**
  # Skim

  Skim fuzzy finder, with custom setup & aliases

  ## 🙇 Acknowledgements

  - [Supercharging the shell @ On data, programming, and technology](https://ivergara.github.io/Supercharging-shell.html).
*/
{
  writeShellApplication,
  biapy-parts,
  gum,
  vscodium,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skrg;
in
writeShellApplication {
  name = "skrodium";
  runtimeInputs = [
    gum
    skrg
    vscodium
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skrodium.sh;
}
