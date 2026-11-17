{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "c1c8a8c1471069fb0e188eeaff69b8e8db6564a8";
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "security-audit-skill";
    rev = "c1c8a8c1471069fb0e188eeaff69b8e8db6564a8";
    hash = "sha256-oVVACjotkHvllQGxEP8yWaEt4c3GxT0d909TUM5P3NM=";
  };
in
stdenv.mkDerivation {
  pname = "cloudflare-security-audit-skill";
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "''${out}"
    cp -r "skills/" "''${out}"
  '';

  meta = {
    description = "A coding-agent skill for multi-phase security audits with independently verified, machine-readable findings";
    homepage = "https://github.com/cloudflare/security-audit-skill";
    license = lib.licenses.mit;
  };
}
