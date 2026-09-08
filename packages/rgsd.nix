{
  writeShellApplication,
  lib,
  uutils-findutils,
  ripgrep,
  sd,
}:
let
  inherit (lib.meta) getExe getExe';

  rgCmd = getExe ripgrep;
  sdCmd = getExe sd;
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "rgsd";
  runtimeInputs = [
    ripgrep
    sd
    uutils-findutils
  ];
  text = ''
    if [[ ''${#} -lt 2 || ''${#} -gt 3 ]]; then
      cat >&2 <<EOF
    Usage: ''${0##*/} <search> <replace> [path]"
    Tip: consider using ambr
    EOF
      exit 1
    fi

    search="''${1}"
    replace="''${2}"
    path="''${3:-.}"

    ${rgCmd} --files-with-matches "''${search}" "''${path}" \
      | exec ${xargsCmd} -I{} ${sdCmd} "''${search}" "''${replace}" {}
  '';
}
