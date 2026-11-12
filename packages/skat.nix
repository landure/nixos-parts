{
  writeShellApplication,
  biapy-parts,
  gum,
  bat,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skf;
in
writeShellApplication {
  name = "skat";
  runtimeInputs = [
    skf
    gum
    bat
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skat.sh;
}
