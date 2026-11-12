{
  writeShellApplication,
  biapy-parts,
  gum,
  helix,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skrg;
in
writeShellApplication {
  name = "skrhx";
  runtimeInputs = [
    skrg
    gum
    helix
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skrhx.sh;
}
