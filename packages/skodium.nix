/**
  # skodium

  Select file with skf, and open it with Visual Studio Codium (codium)

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
  inherit (biapy-parts) skf;
in
writeShellApplication {
  name = "skodium";
  runtimeInputs = [
    gum
    skf
    vscodium
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skodium.sh;
}
