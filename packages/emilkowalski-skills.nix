{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "2026.11.15";
  src = fetchFromGitHub {
    owner = "emilkowalski";
    repo = "skills";
    rev = "64eb3deb9a5fbfa041faf783e0bc3fd635872e9c";
    hash = "sha256-zZnblPcn3vvekGH4YIHMOZ2XMA3sBngwhwLBnNFpD/E=";
  };
in
stdenv.mkDerivation {
  pname = "emilkowalski-skills";
  inherit version src;

  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "Skills for Designers and Engineers.";
    homepage = "https://aiforui.dev/skills";
    license = lib.licenses.mit;
  };
}
