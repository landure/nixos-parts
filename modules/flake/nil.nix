/**
  # nil

  An incremental analysis assistant for writing in Nix.

  ## 🛠️ Tech Stack

  - [nil @ GitHub](https://github.com/oxalica/nil).

  ### Dependencies

  - [devshell homepage](https://numtide.github.io/devshell/)
    ([devshell @ GitHub](https://github.com/numtide/devshell)).
  - [flake-parts homepage](https://flake.parts/)
    ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).

  ## 🙇 Acknowledgements

  - [Dendrix](https://dendrix.oeiuwq.com/index.html).
*/
{
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkDefault getExe;
in
{
  flake-file = {
    inputs = {
      devshell.url = mkDefault "github:numtide/devshell";
    };

    check-hooks = [
      {
        index = 10;
        program =
          pkgs:
          pkgs.writeShellApplication {
            name = "nil-diagnostics";
            text = ''
              shopt -s globstar

              flake_path="''${1}"

              ${getExe pkgs.nil} diagnostics --deny-warnings "''${flake_path}/"**/*.nix
            '';
          };
      }
    ];
  };

  imports = [
    (inputs.devshell.flakeModule or { })
  ];

  perSystem =
    { lib, pkgs, ... }:
    let
      inherit (lib) getExe;
    in
    {
      devshells.default = {
        packages = with pkgs; [ nil ];

        commands = [
          {
            name = "nil-diagnostics";
            help = "Lint nix files with nil";
            command = ''
              shopt -s globstar
              ${getExe pkgs.nil} diagnostics "''${PRJ_ROOT}"/**/*.nix
            '';
            category = "lint";
          }
        ];
      };
    };
}
