{
  writeShellApplication,
  lib,
  local,
  bat,
  ripgrep,
  skim,
  uutils-coreutils-noprefix,
  uutils-findutils,
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (local) batline;

  batCmd = getExe bat;
  batlineCmd = getExe batline;
  rgCmd = getExe ripgrep;
  skCmd = getExe skim;
  testCmd = getExe' uutils-coreutils-noprefix "test";
  xargsCmd = getExe' uutils-findutils "xargs";
in
writeShellApplication {
  name = "skrat";
  runtimeInputs = [
    bat
    batline
    ripgrep
    skim
    uutils-coreutils-noprefix
    uutils-findutils
  ];
  text = ''
    # Live grep

    rg_command=(${rgCmd} --line-number --no-heading --color='always')

    # shellcheck disable=SC2016 # --preview option requires some math expressions
    ${skCmd} --ansi --delimiter=':' --interactive \
    	--no-multi --no-height --exit-0 --select-1 --output-format='{1..2}' \
    	--cmd="''${rg_command[*]} {q}" \
    	--skip-to-pattern='[^/]*:' \
    	--preview='${testCmd} -e {1} && ${batlineCmd} --style=numbers --color=always --auto-range {1..2}'  \
    	--preview-window='right:70%:nowrap' \
    	--cmd-query="''${*}" |
    	${xargsCmd} --no-run-if-empty ${batlineCmd}
  '';
}
