/**
  # gh-secure

  GitHub CLI extension to enable security features on repositories
  following best practices from GitHub Security Lab.

  ## 🛠️ Tech Stack

  - [gh-secure @ GitHub](https://github.com/GitHubSecurityLab/gh-secure).
*/
{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gh,
  jq,
}:
stdenv.mkDerivation {
  pname = "gh-secure";
  version = "v0.1.0";

  src = fetchFromGitHub {
    owner = "GitHubSecurityLab";
    repo = "gh-secure";
    rev = "42c928f94b61caae03774d2436b897a1d04fff20";
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
