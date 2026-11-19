{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "58a680ffb61d126c8271b9a033a13332a3f016c2";
  src = fetchFromGitHub {
    owner = "ioma8";
    repo = "hypothesis-debugging";
    rev = version;
    hash = "sha256-angDrpEi0e9f76uglbwf3bAtuqg41Cap8DJzlmhMmLY=";
  };
in
stdenv.mkDerivation {
  pname = "hypothesis-debugging";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "Agent skill for hypothesis-driven debugging — one testable hypothesis at a time, logged and validated in a CSV loop";
    homepage = "https://github.com/ioma8/hypothesis-debugging";
    license = lib.licenses.mit;
  };
}
