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
  vscode,
  uutils-findutils,
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (local) skrg;

  skrgCmd = getExe skrg;
  codeCmd = getExe vscode;
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "skrode";
  meta = {license = lib.licenses.unfree;};
  runtimeInputs = [
    skrg
    vscode
    uutils-findutils
  ];
  text = ''
    # Open with Visual Studio Code
    # see https://ivergara.github.io/Supercharging-shell.html
    ${skrgCmd} --no-multi --output-format='{1..2}' "''${@}" |
    	${xargsCmd} --no-run-if-empty ${codeCmd}
  '';
}
