/**
  # mq

  jq-like query language for Markdown: slice, filter, map and transform
  structured Markdown from the command line.

  ## 🛠️ Tech Stack

  - [mq @ GitHub](https://github.com/harehare/mq).
  - [mq documentation](https://mqlang.org).
*/
{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage (final: {
  pname = "mq";
  version = "0.10.2";
  src = fetchFromGitHub {
    owner = "harehare";
    repo = "mq";
    tag = "v${final.version}";
    hash = "sha256-DAl40co43QA4uExiIO6Mqyrj+seRO63xnuu3/bKWDpc=";
  };

  cargoHash = "sha256-x7kXFIyumA3IhFubF5MElNAzrWYxAQp2SCoo02qF+A4=";

  cargoBuildFlags = [
    "-p"
    "mq-run"
    "-p"
    "mq-crawler"
  ];

  # Scope the test run to mq-run: mq-crawler's tests need network access,
  # which the sandbox blocks.
  cargoTestFlags = [
    "-p"
    "mq-run"
  ];

  # Ship the upstream agent skills alongside the binary.
  postInstall = ''
    cp -r skills "$out"
  '';

  meta = {
    description = "jq-like query language for Markdown processing";
    homepage = "https://mqlang.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "mq";
  };
})
