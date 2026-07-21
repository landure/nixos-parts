{
  writeShellApplication,
  lib,
  local,
  ripgrep,
  skim,
  uutils-coreutils-noprefix,
}:
let
  inherit (lib.meta) getExe getExe';
  inherit (local) batline;

  batlineCmd = getExe batline;
  rgCmd = getExe ripgrep;
  skCmd = getExe skim;
  testCmd = getExe' uutils-coreutils-noprefix "test";
in
writeShellApplication {
  name = "skrg";
  runtimeInputs = [
    batline
    ripgrep
    skim
    uutils-coreutils-noprefix
  ];
  text = ''
    # Live grep
    rg_command=(${rgCmd} --line-number --no-heading --color='always')

    # Parse arguments: everything before -- is for skim, everything after is for rg
    sk_args=()

    # Parse arguments using while and shift
    while [[ "''${#}" -gt 0 && "''${1}" =~ ^- && "''${1}" != '--' ]]; do
      option="''${1}"
      shift
      
      sk_args+=("''${option}")
    done

    ${skCmd} --ansi --delimiter=':' --interactive \
    	--no-height --prompt='rg❯ ' \
    	--cmd="''${rg_command[*]} {q}" \
    	--skip-to-pattern='[^/]*:' \
    	--preview='${testCmd} -e {1} && ${batlineCmd} --style=numbers --color=always --auto-range {1..2}'  \
    	--preview-window='right:60%:nowrap' \
    	"''${sk_args[@]}" \
    	--cmd-query="''${*}"
  '';
}
