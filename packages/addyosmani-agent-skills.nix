{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "0.6.17";
  src = fetchFromGitHub {
    owner = "addyosmani";
    repo = "agent-skills";
    tag = version;
    hash = "sha256-LqVRMZ5sSxXkCt5/PwYeJeiJxpQtAdUuQYIDrcQH1+A=";
  };
in
stdenv.mkDerivation {
  pname = "addyosmani-agent-skills";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "Production-grade engineering skills for AI coding agents covering the full software development lifecycle from spec to ship";
    homepage = "https://skills.addy.ie";
    license = lib.licenses.mit;
  };
}
