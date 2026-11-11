{
  writeShellApplication,
  biapy-parts,
  gum,
  ripgrep,
  skim,
  uutils-coreutils-noprefix,
}:
let
  inherit (biapy-parts) batline;
in
writeShellApplication {
  name = "skrg";
  runtimeInputs = [
    batline
    gum
    ripgrep
    skim
    uutils-coreutils-noprefix
  ];
  text = builtins.readFile ../chezmoi-dot-files/private_dot_local/bin/executable_skrg;
}
