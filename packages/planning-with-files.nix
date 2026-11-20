{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "3.28.1";
  src = fetchFromGitHub {
    owner = "OthmanAdi";
    repo = "planning-with-files";
    tag = "v${version}";
    hash = "sha256-4JZLrDUshvvOh/BysJnbgcT0R5ZZ0RBl/uKz3vyjvAg=";
  };
in
stdenv.mkDerivation {
  pname = "planning-with-files";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "''${out}"
    cp -r .claude-plugin .codex-plugin .codex .continue .cursor .dsh .factory \
        .gemini .hermes .kiro .mastracode .opencode .pi .qoder-plugin \
        commands hooks scripts skills templates "''${out}/"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Persistent file-based planning for AI coding agents, with OpenCode and Claude Code plugins";
    homepage = "https://planningwithfiles.tech/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
