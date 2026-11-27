{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "0.13.1";
  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = "ctx7@${version}";
    hash = "sha256-73TS4SEp6iQjCeUns0llqgk0Wa+amZI56pxooCFZ9KQ=";
  };
in
stdenv.mkDerivation {
  pname = "context7-skills";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r 'plugins' 'rules' 'skills' "''${out}"
  '';

  meta = {
    description = "Context7 agent skills.";
    homepage = "https://jeffallan.github.io/claude-skills";
    license = lib.licenses.mit;
  };
}
