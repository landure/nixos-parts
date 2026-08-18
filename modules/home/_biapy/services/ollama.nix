/**
  # Ollama

  Run DeepSeek-R1, Qwen 3, Llama 3.3, Qwen 2.5‑VL, Gemma 3, and other models,
  locally.

  ## 🛠️ Tech Stack

  - [Ollama homepage](https://ollama.com/).
  - [Ollama @ GitHub](https://github.com/ollama/ollama).

  ## 📝 Documentation

  - [envconfig/config.go @ Ollama's GitHub](https://github.com/ollama/ollama/blob/main/envconfig/config.go).

  ### 🏠 Home Manager

  - [services.ollama @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.enable).
  - [services.ollama @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.ollama.).

  ## 🙇 Acknowledgements

  - [Ollama @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Ollama).
  - [FAQ @ Ollama's GitHub](https://github.com/ollama/ollama/blob/main/docs/faq.md).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.biapy.services.ollama;
in
{
  options = {
    biapy.services.ollama = {
      enable = mkEnableOption "Ollama service";

      api-base = mkOption {
        type = str;
        description = "Ollama service API URL";
        readOnly = true;
      };
    };
  };

  config = mkIf cfg.enable {
    cfg.api-base =
      "http://${config.services.ollama.host}:${builtins.toString config.services.ollama.port}/v1";

    services.ollama = {
      enable = mkDefault true;

      # host = mkDefault "127.0.0.1";
      # port = mkDefault 11434;

      # loadModels = [
      #   "mistral-small3.1:latest"
      #   "deepseek-r1:8b"
      #   "qwen2.5-coder:1.5b"
      # ];

      environmentVariables = {
        # OLLAMA_ORIGINS = "http://localhost:3000,http://127.0.0.1:3000";

        # increase the context window to 8k tokens
        OLLAMA_CONTEXT_LENGTH = mkDefault "8192";

        # Maximum number of loaded models per GPU.
        # The maximum number of models that can be loaded concurrently provided they
        # fit in available memory.
        # The default is 3 * the number of GPUs or 3 for CPU inference.
        OLLAMA_MAX_LOADED_MODELS = mkDefault "1";

        # The duration that models stay loaded in memory
        # Negative values are treated as infinite. Zero is treated as no keep alive.
        OLLAMA_KEEP_ALIVE = mkDefault "5m0s";

        # sets a maximum VRAM override in bytes.
        # OLLAMA_MAX_VRAM = 0;
        # Reserve a portion of VRAM per GPU (bytes)
        # OLLAMA_GPU_OVERHEAD = 1073741824;

        OLLAMA_NUM_PARALLEL = mkDefault "4";
        # OLLAMA_MODELS=/opt/ollama-models

        # maximum number of requests Ollama will queue when busy before rejecting
        # additional requests. The default is 512
        # OLLAMA_MAX_QUEUE = 512;

        # NVIDIA GPU optimization
        # CUDA_VISIBLE_DEVICES = 0;
        # 1.5GB overhead
        # OLLAMA_GPU_OVERHEAD = 1536000000;

        # AMD GPU configuration (ROCm)
        # HSA_OVERRIDE_GFX_VERSION = 10.3.0;
        # OLLAMA_GPU_LAYERS = 32;

        # Intel GPU setup (upcoming support)
        # OLLAMA_INTEL_GPU = 1;

        # Conservative memory settings
        # OLLAMA_NUM_PARALLEL = 1;
        # OLLAMA_MAX_LOADED_MODELS = 1;
        # OLLAMA_KEEP_ALIVE = 0;

        # Flash Attention is a feature of most modern models that can significantly
        # reduce memory usage as the context size grows.
        # Set to 1 to enable
        OLLAMA_FLASH_ATTENTION = mkDefault "1";

        # The K/V context cache can be quantized to significantly reduce memory usage
        # when Flash Attention is enabled.
        # quantization type for the K/V cache. Default is f16.
        # The currently available K/V cache quantization types are:
        # - f16 - high precision and memory usage (default).
        # - q8_0 - 8-bit quantization, uses approximately 1/2 the memory of f16 with
        #   a very small loss in precision, this usually has no noticeable impact on
        #   the model's quality (recommended if not using f16).
        # - q4_0 - 4-bit quantization, uses approximately 1/4 the memory of f16 with a
        #   small-medium loss in precision that may be more noticeable at higher context sizes.
        # OLLAMA_KV_CACHE_TYPE=f16

        # Enable memory debugging
        # OLLAMA_DEBUG = 1;
      };
    };

    # self-hosted chatgpt
    # service.open-webui.enable = true;
  };
}
