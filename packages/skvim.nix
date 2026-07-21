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
  inherit (local) skf;

  skfCmd = getExe skf;
  vimCmd = getExe neovim;
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "skvim";
  runtimeInputs = [
    skf
    neovim
    uutils-findutils
  ];
  text = ''
    # Open with Neovim.
    # see https://ivergara.github.io/Supercharging-shell.html
    ${skfCmd} --no-multi "''${@}" |
    	${xargsCmd} --no-run-if-empty ${vimCmd}
  '';
}
