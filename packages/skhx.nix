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
  helix,
  uutils-findutils,
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (local) skf;

  skfCmd = getExe skf;
  hxCmd = getExe helix;
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "skhx";
  runtimeInputs = [
    skf
    helix
    uutils-findutils
  ];
  text = ''
    # Open with Helix.
    # see https://ivergara.github.io/Supercharging-shell.html
    ${skfCmd} --no-multi "''${@}" |
    	exec ${xargsCmd} --no-run-if-empty ${hxCmd}
  '';
}
