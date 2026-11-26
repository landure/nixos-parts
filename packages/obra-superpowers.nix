{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "7.0.2";
  src = fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    tag = "v${version}";
    hash = "sha256-rP5YsyGuPd9YSW/Fj3aukrq1bLuV+nwwQMK4JaZQgkI=";
  };
in
stdenv.mkDerivation {
  pname = "obra-superpowers";
  inherit version src;

  installPhase = ''
    mkdir -p "''${out}"
    cp -r .antigravity-plugin .claude-plugin .codex-plugin .cursor-plugin \
        .devin-plugin .hermes-plugin .kimi-plugin .muse-plugin .opencode .pi \
        hooks skills gemini-extension.json "''${out}"
  '';

  meta = {
    description = "An agentic skills framework & software development methodology that works.";
    homepage = "https://github.com/obra/superpowers";
    license = lib.licenses.mit;
  };
}
