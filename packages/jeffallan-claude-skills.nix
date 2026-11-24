{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "0.5.2";
  hash = "sha256-ZMJUB/i3PUiv7T8HXSXb40+i88Qzz0yVKFVFw4OX9wA=";
in
stdenv.mkDerivation {
  pname = "jeffallan-claude-skills";
  inherit version;

  src = fetchFromGitHub {
    owner = "Jeffallan";
    repo = "claude-skills";
    tag = "v${version}";
    inherit hash;
  };

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r 'plugin/.claude-plugin' 'plugin/agents' 'plugin/commands' \
        'plugin/hooks' 'plugin/references' 'plugin/runtime' 'plugin/skills' \
        "''${out}"
  '';

  meta = {
    description = "67 Specialized Skills for Full-Stack Developers. Transform Claude Code into your expert pair programmer.";
    homepage = "https://jeffallan.github.io/claude-skills";
    license = lib.licenses.mit;
  };
}
