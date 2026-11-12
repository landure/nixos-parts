{
  writeShellApplication,
  bat,
  gum,
  skim,
}:
writeShellApplication {
  name = "skf";
  runtimeInputs = [
    bat
    gum
    skim
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/skf.sh;
}
