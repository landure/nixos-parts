{
  writeShellApplication,
  bat,
  gum,
  less,
  ncurses,
}:
writeShellApplication {
  name = "batline";
  runtimeInputs = [
    bat
    gum
    less
    ncurses
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/executable_batline;
}
