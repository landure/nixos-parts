{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "5.3.3";
  src = fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    tag = "v${version}";
    hash = "sha256-CY0EifTY0UVc6/FPGVJjEfYEf/8QLsINQmoYYKZYh98=";
  };
in
stdenv.mkDerivation {
  pname = "ponytail";
  inherit version src;

  installPhase = ''
    mkdir -p "''${out}"
    cp -r ./ "''${out}"
    # remove unwanted content
    rm -r "''${out}/.github"
    rm -r "''${out}/assets"
    rm -r "''${out}/benchmarks"
    rm -r "''${out}/docs"
    rm -r "''${out}/examples"
    rm -r "''${out}/i18n"
    rm -r "''${out}/scripts"
    rm -r "''${out}/tests"
    rm '.gitignore' 'INSTALL.md' 'LICENSE' 'README.md'
  '';

  meta = {
    description = "Makes your AI agent think like the laziest senior dev in the room. The best code is the code you never wrote.";
    homepage = "https://ponytail.dev/";
    license = lib.licenses.mit;
  };
}
