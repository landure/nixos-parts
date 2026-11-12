{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "1.3.2";
  src = fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    tag = "v${version}";
    hash = "sha256-ej0ATi0BWaAx+83dBwgCQxr9J2L2qEwKhUIeIRJ03Go=";
  };
in
stdenv.mkDerivation {
  pname = "mattpocock-skills";
  inherit version src;

  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "A practical skill system for engineers who want to use AI without giving up their standards. Install the ones you want, then type a slash command.";
    homepage = "https://www.aihero.dev/skills";
    license = lib.licenses.mit;
  };
}
