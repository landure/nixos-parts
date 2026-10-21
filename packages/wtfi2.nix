/**
  # What The F*ck Internet (wtfi2)

  a live, visual network-path diagnostic that pinpoints exactly
  where your connection dies, and tells you how to fix it.

  ## 🛠️ Tech Stack

  - [What The F*ck Internet (wtfi2) @ GitHub](https://github.com/kanywst/wtfi2).
*/
{
  rustPlatform,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (final: {
  pname = "wtfi2";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "kanywst";
    repo = "wtfi2";
    tag = "v${final.version}";
    hash = "sha256-vkshSHAOKwKs1CVCyiXI4VbQ8Q6DYmmGPaqE9PU7ofo=";
  };

  cargoHash = "sha256-7uXeKkJZpj8GdMQfl9nePmW59wjti9YytaUoaeKjN0s=";

  checkFlags = [
    # In the sandbox probes fail instantly (no network), so a 1ms sweep still
    # lands measured (failed) hops; the test assumes truncation before any probe
    # answers, which holds only on a real network.
    "--skip=a_truncated_sweep_reports_the_gap_rather_than_a_verdict"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Live, visual network-path diagnostic that pinpoints exactly where your Wi-Fi connection dies — and how to fix it";
    homepage = "https://github.com/kanywst/wtfi2";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "wtfi";
  };
})
