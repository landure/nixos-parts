/**
  # lazes

  `lazes` is a `ls` compatibility wrapper for [eza](https://eza.rocks/).

  ## 🙇 Acknowledgements

  - [default -t to modified -r to be backward compatible with ls @ eza's GitHub](https://github.com/eza-community/eza/issues/980).
*/
{
  writeShellApplication,
  eza,
  gum,
}:
writeShellApplication {
  name = "lazes";
  runtimeInputs = [
    eza
    gum
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/lazes.sh;
}
