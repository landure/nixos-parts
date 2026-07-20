{
  writeShellApplication,
  lib,
  bat,
  less,
  ncurses,
}:
let
  inherit (lib.meta) getExe getExe';

  batCmd = getExe bat;
  lessCmd = getExe less;
  tputCmd = getExe' ncurses "tput";
in
writeShellApplication {
  name = "batline";
  runtimeInputs = [
    bat
    less
    ncurses
  ];
  text = ''
    # Highlight a line.

    # Parse arguments: everything before -- is for bat, everything after is for us
    args=()
    auto_range=0

    # Parse arguments using while and shift
    while [[ "''${#}" -gt 0 && "''${1}" =~ ^- && "''${1}" != '--' ]]; do
      option="''${1}"
      shift
      
      if [[ "''${option}" == '--auto-range' ]]; then
        auto_range=1
        continue
      fi

    	args+=("''${option}")
    done

    if [[ "''${1}" == '--' ]]; then
    	args+=("''${1}")
    	shift
    fi

    if [[ ''${#} -ne 1 ]]; then
    	echo "Error: ''${0##*/} requires one and only one argument in the format 'path:line-number' after options, ''${#} given." >&2
    	exit 1
    fi

    # bat file as is if no line given
    [[ "''${1}" =~ .*:[0-9]+$ ]] || exec ${batCmd} "''${args[@]}" "''${1}"

    line="''${1##*:}"
    file="''${1%:*}"

    if [[ -z "''${file}" ]]; then
    	echo "Error: path is required" >&2
    	exit 1
    fi

    if [[ ! "''${line}" =~ [0-9]+ ]]; then
      echo "Error: line number \"''${line}\" isn't numeric" >&2
      exit 1
    fi

    if [[ "''${auto_range}" -ne 0 ]]; then
      height="''$(${tputCmd} 'lines')"

      start=$((line > height / 2 ? line - (height / 2) : 0))

      args+=("--line-range=''${start}:+''$((height * 2))")

      exec ${batCmd} "''${args[@]}" --highlight-line="''${line}" "''${file}"
    fi

    pager=(
    	${lessCmd} --RAW-CONTROL-CHARS --quit-if-one-screen
    	--jump-target='.5' "+''${line}g"
    )

    exec ${batCmd} "''${args[@]}" --pager="''${pager[*]}" --highlight-line="''${line}" "''${file}"
  '';
}
