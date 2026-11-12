{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "20.7.0";
  src = fetchFromGitHub {
    owner = "sickn33";
    repo = "agentic-awesome-skills";
    tag = "v${version}";
    hash = "sha256-vMfUXqE7PhFtA/evn2q+1YgT0O3/Tiz9Bawu4bnp/ws=";
  };
in
stdenv.mkDerivation {
  pname = "agentic-awesome-skills";
  inherit version src;

  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
    # remove symbolic links.
    rm "''${out}/skills/pdf" "''${out}/skills/xlsx"
    for file in README.md LICENSE LICENSE-CONTENT; do
      cp "''${file}" "''${out}/''${file}"
    done
  '';

  meta = {
    description = "Reusable AI agent skills for Claude Code, Codex, Cursor and Gemini CLI";
    homepage = "https://github.com/sickn33/agentic-awesome-skills";
    license = lib.licenses.cc-by-40;
  };
}
