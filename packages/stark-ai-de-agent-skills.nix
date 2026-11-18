{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "0.34.0";
  src = fetchFromGitHub {
    owner = "stark-ai-de";
    repo = "agent-skills";
    tag = "v${version}";
    hash = "sha256-K8Tu9vEqERWGNOsgJWDk5LTx0w1mxhFvVMWoOGehKDE=";
  };
in
stdenv.mkDerivation {
  pname = "stark-ai-de-agent-skills";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "Agent skills for codex, cursor and claude operations, plus portable engineering workflows.";
    homepage = "https://github.com/stark-ai-de/agent-skills";
    license = lib.licenses.asl20;
  };
}
