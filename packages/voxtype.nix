{ pkgs, ... }:
let
  inherit (pkgs) callPackage fetchFromGitHub;

  voxtypePR = fetchFromGitHub {
    owner = "DuskyElf";
    repo = "nixpkgs";
    rev = "9b3e13aff561180f740f652bce928b85bf9d78ee";
    sha256 = "sha256-/gB+EcsN/k6gmc5Jem6fAEbMiKcJPw7CWUgNdAncL2E=";
  };

in
callPackage "${voxtypePR}/pkgs/by-name/vo/voxtype/package.nix" { }
