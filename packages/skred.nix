{
  writeShellApplication,
  biapy-parts,
  gum,
  nano,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skrg;
in
writeShellApplication {
  name = "skred";
  runtimeInputs = [
    skrg
    gum
    nano
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skred.sh;
}
