{
  writeShellApplication,
  lib,
  biapy-parts,
  uutils-findutils,
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (biapy-parts) batline skrg;

  batlineCmd = getExe batline;
  skrgCmd = getExe skrg;
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "skrat";
  runtimeInputs = [
    batline
    skrg
    uutils-findutils
  ];
  text = ''
    # Live grep to bat preview
    ${skrgCmd} --no-multi --output-format='{1..2}' "''${@}" |
    	exec ${xargsCmd} --no-run-if-empty ${batlineCmd}
  '';
}
