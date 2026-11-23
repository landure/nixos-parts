/**
  # llm-visuals

  Live truecolor terminal dashboard for a locally running LLM:
  tok/s, TTFT, GPUs, context, MTP acceptance, layer,
  and real expert routing (llama.cpp)

  ## 🛠️ Tech Stack

  - [llm-visuals @ GitHub](https://github.com/DingoOz/llm-visuals)
*/
{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage (final: {
  pname = "llm-visuals";
  version = "0.14.0";
  src = fetchFromGitHub {
    owner = "DingoOz";
    repo = "llm-visuals";
    tag = "v${final.version}";
    hash = "sha256-KcAIuvnfVvDcqo8iuM75Q6CEobtAJJQ71t/EAuUYGfE==";
  };

  cargoHash = "sha256-hf9OfbWefyff8JVPnok7kRyzBa04xsVdfY6lVbGwvbw=";

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
