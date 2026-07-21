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
  vscodium,
  uutils-findutils,
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (local) skf;

  skfCmd = getExe skf;
  codeCmd = getExe vscodium;
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "skodium";
  runtimeInputs = [
    skf
    vscodium
    uutils-findutils
  ];
  text = ''
    # Open with Visual Studio Code
    # see https://ivergara.github.io/Supercharging-shell.html
    ${skfCmd} --no-multi "''${@}" |
    	${xargsCmd} --no-run-if-empty ${codeCmd}
  '';
}
