{
  writeShellApplication,
  lib,
  bat,
  skim,
}:
let
  inherit (lib.meta) getExe;

  batCmd = getExe bat;
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
    ${skCmd} --ansi --prompt='Files❯ ' --no-height \
      --bind='ctrl-p:toggle-preview' \
      --preview='${batCmd} --style=numbers --color=always --line-range :500 {}' \
      --preview-window='right:60%:nowrap'
  '';
}
