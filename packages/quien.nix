/**
  # quien

  quien is a better `whois` and domain intelligence toolkit.

  ## 🛠️ Tech Stack

  - [quien @ GitHub](https://github.com/retlehs/quien)
*/
{ inputs, stdenv, ... }:
let
  inherit (stdenv.hostPlatform) system;
  inherit (inputs.quien.packages."${system}") quien;
in
quien
