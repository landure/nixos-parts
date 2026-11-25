{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "2026.3.5";
  src = fetchFromGitHub {
    owner = "softaworks";
    repo = "agent-toolkit";
    rev = "3027f20f3181758385a1bb8c022d4041dfb4de84";
    hash = "sha256-1q4IP55kvZhJibTLJct0SSifw46lBmAQhp9nSmDzYxs=";
  };
in
stdenv.mkDerivation {
  pname = "softaworks-agent-toolkit";
  inherit version src;

  installPhase = ''
    mkdir -p "''${out}"
    cp -r "dist/plugins/"* "''${out}"
  '';

  meta = {
    description = "A curated collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities across development, documentation, planning, and professional workflows.";
    homepage = "https://github.com/softaworks/agent-toolkit/tree/main";
    license = lib.licenses.mit;
  };
}
