{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "2f3d996c96d8de4b18f129e92f314687b693e221";
  src = fetchFromGitHub {
    owner = "architecture-decision-record";
    repo = "architecture-decision-record";
    rev = version;
    hash = "sha256-H9B5/Rpm70sWaZ1edWgz7F+JhI+21byN93e7zxMy6gU=";
  };
in
stdenv.mkDerivation {
  pname = "architecture-decision-record";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "Agent skill for writing Architecture Decision Records (ADRs): template selection, file naming, and context/decision/consequences sections";
    homepage = "https://architecture-decision-record.github.io/";
    license = lib.licenses.mit;
  };
}
