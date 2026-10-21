{ pkgs, ... }:
pkgs.callPackage (
  { buildGoModule, fetchFromGitHub }:
  buildGoModule (finalAttrs: {
    pname = "quien";
    version = "0.12.0";
    vendorHash = "sha256-7gP6eN+lF90kSltQMHkVTTanogEAtbLnENdZTF9f98c=";
    src = fetchFromGitHub {
      owner = "retlehs";
      repo = "quien";
      tag = "v${finalAttrs.version}";
      hash = "sha256-HTTogbcBa/dOIZAl1sNCqZODlFk50N+94jDxQrWQwb8=";
    };

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
      "-X main.version=${finalAttrs.version}"
    ];
  })
) { }
