{
  writeShellApplication,
  gum,
  ripgrep,
  sd,
  uutils-findutils,
}:
let
in
writeShellApplication {
  name = "rgsd";
  runtimeInputs = [
    gum
    ripgrep
    sd
    uutils-findutils
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/rgsd.sh;
}
