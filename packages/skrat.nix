{
  writeShellApplication,
  biapy-parts,
  gum,
  uutils-findutils,
}:
let
  inherit (biapy-parts) batline skrg;
in
writeShellApplication {
  name = "skrat";
  runtimeInputs = [
    batline
    gum
    skrg
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skrat.sh;
}
