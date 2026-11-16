{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "0.4.20";
  src = fetchFromGitHub {
    owner = "Jeffallan";
    repo = "claude-skills";
    tag = version;
    hash = "sha256-boV0kGmAVlFvZhfIxd8fNhJqkHBfwGrMGhXDInnWLUM=";
  };
in
stdenv.mkDerivation {
  pname = "jeffallan-claude-skills";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r "commands/" "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "67 Specialized Skills for Full-Stack Developers. Transform Claude Code into your expert pair programmer.";
    homepage = "https://jeffallan.github.io/claude-skills";
    license = lib.licenses.mit;
  };
}
