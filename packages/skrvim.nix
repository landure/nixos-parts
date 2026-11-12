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
  neovim,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skrg;
in
writeShellApplication {
  name = "skrvim";
  runtimeInputs = [
    gum
    skrg
    neovim
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skrvim.sh;
}
