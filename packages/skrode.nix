{
  writeShellApplication,
  lib,
  biapy-parts,
  gum,
  vscode,
  uutils-findutils,
}:
let
  inherit (biapy-parts) skrg;
in
writeShellApplication {
  name = "skrode";
  meta = {
    license = lib.licenses.cc-by-nc-sa-40;
  };
  runtimeInputs = [
    gum
    skrg
    vscode
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skrode.sh;
}
