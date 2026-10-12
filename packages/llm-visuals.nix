{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage (final: {
  pname = "llm-visuals";
  version = "0.12.0";
  src = fetchFromGitHub {
    owner = "DingoOz";
    repo = "llm-visuals";
    tag = "v${final.version}";
    hash = "sha256-5/ntkkN0WtPOo3J7YpDKk4qc012FtHNwrzOIlkBDqcI=";
  };

  cargoHash = "sha256-L87NsbTonEXrxq0xNmLX8EvpmdY5tmu1yO0dWWWOdD4=";

  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Live truecolor terminal dashboard for a locally running LLM: tok/s, TTFT, GPUs, context, MTP acceptance, layer and real expert routing (llama.cpp)";
    homepage = "https://github.com/DingoOz/llm-visuals";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "llm-visuals";
  };
})
