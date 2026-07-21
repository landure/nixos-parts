{
  writeShellApplication,
  lib,
  bat,
  fd,
  skim,
}:
let
  inherit (lib.meta) getExe;

  batCmd = getExe bat;
  fdCmd = getExe fd;
  skCmd = getExe skim;
in
writeShellApplication {
  name = "skf";
  runtimeInputs = [
    bat
    skim
  ];
  text = ''
    # A comfortable UI + preview
    # Parse arguments: everything before -- is for skim, everything after is the query
    sk_args=()

    # Parse arguments using while and shift
    while [[ "''${#}" -gt 0 && "''${1}" =~ ^- && "''${1}" != '--' ]]; do
      option="''${1}"
      shift

      if [[ "''${option}" != '--' ]]; then
        sk_args+=("''${option}")
      fi
    done

    exec ${skCmd} --ansi --prompt='Files❯ ' --no-height \
      --bind='ctrl-p:toggle-preview' \
      --preview='${batCmd} --style=numbers --color=always --line-range :500 {}' \
      --preview-window='right:60%:nowrap' \
      "''${sk_args[@]}" --query="''${*}"
  '';
}
