{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "amElnagdy";
    repo = "guard-skills";
    tag = "v${version}";
    hash = "sha256-Dwmz7oByIHLj42WjxbrQ5w1tI5SIHV1rRs+yBn/uI6c=";
  };
in
stdenv.mkDerivation {
  pname = "guard-skills";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "Guard skills for coding agents, quality gates that catch AI-generated failure modes in code, tests, and docs";
    homepage = "https://github.com/amElnagdy/guard-skills";
    license = lib.licenses.mit;
  };
}
