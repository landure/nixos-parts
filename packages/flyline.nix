/**
  # Flyline

  Flyline is a Bash plugin to replace readline for a modern line editing
  experience: syntax highlighting, agent integration, rich prompts,
  tooltips, fuzzy history search, and more!

  ## 🛠️ Tech Stack

  - [Flyline @ GitHub](https://github.com/HalFrgrd/flyline)
*/
{ inputs, stdenv, ... }:
let
  inherit (stdenv.hostPlatform) system;
  inherit (inputs.flyline.packages."${system}") flyline;
in
flyline
