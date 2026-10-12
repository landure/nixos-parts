{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gh,
  jq,
}:

stdenv.mkDerivation rec {
  pname = "gh-secure";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GitHubSecurityLab";
    repo = "gh-secure";
    rev = "a04d1c144f5d1b63a8aa5cd7946e8ceafa709a2a";
    hash = "sha256-oDPZ1qfw8vzOXdyarhmvhDghJmvvk7sP6HN9/k1BLQ0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/gh-secure $out/bin/gh-secure
    chmod +x $out/bin/gh-secure
    wrapProgram $out/bin/gh-secure \
      --prefix PATH : ${
        lib.makeBinPath [
          gh
          jq
        ]
      }
    runHook postInstall
  '';

  meta = {
    description = "GitHub CLI extension to enable security features on repositories following best practices from GitHub Security Lab";
    homepage = "https://github.com/GitHubSecurityLab/gh-secure";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "gh-secure";
  };
}
