/**
  # Skim

  Skim fuzzy finder, with custom setup & aliases

  ## 🙇 Acknowledgements

  - [Supercharging the shell @ On data, programming, and technology](https://ivergara.github.io/Supercharging-shell.html).
*/
{
  writeShellApplication,
  lib,
  local,
  neovim,
  uutils-findutils,
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (local) skrg;

  skrgCmd = getExe skrg;
  vimCmd = getExe neovim;
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "skrvim";
  runtimeInputs = [
    skrg
    neovim
    uutils-findutils
  ];
  text = ''
    # Open with Neovim.
    # see https://ivergara.github.io/Supercharging-shell.html
    ${skrgCmd} --no-multi --output-format='{1..2}' "''${@}" |
    	exec ${xargsCmd} --no-run-if-empty ${vimCmd}
  '';
}
