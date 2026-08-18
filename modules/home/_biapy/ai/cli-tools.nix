/**
  # AI command-line tools

  ## 🛠️ Tech Stack

  - [llm ](https://llm.datasette.io/en/stable/)
    ([llm @ GitHub](https://github.com/simonw/llm))
    is a CLI tool and Python library for interacting with Large Language Models.
  - [llmfit @ GitHub](https://github.com/AlexsJones/llmfit)
    right-sizes LLM models to the system's RAM, CPU, and GPU.
  - [whichllm @ GitHub](https://github.com/Andyyyy64/whichllm)
    finds the local LLM that actually runs and performs best on the local hardware.

  ## 🙇 Acknowledgements

  - [Gorilla CLI @ GitHub](https://github.com/gorilla-llm/gorilla-cli).
  - [Tenere @ GitHub](https://github.com/pythops/tenere).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.ai.cli-tools;

in
{
  options = {
    biapy.ai.cli-tools.enable = mkEnableOption "command-line AI tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      llm
      llmfit
      whichllm
    ];
  };
}
