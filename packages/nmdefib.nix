{
  writeShellApplication,
  iputils,
  util-linux,
  fping,
  bind,
  gum,
}:
writeShellApplication {
  name = "nmdefib";
  runtimeInputs = [
    iputils
    util-linux
    fping
    bind
    gum
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/nmdefib.sh;
}
