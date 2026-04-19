/**
  # nixf

  ## 🛠️ Tech Stack

  - [nixd @ GitHub](https://github.com/nix-community/nixd).
  - [nixf-diagnose @ GitHub](https://github.com/inclyc/nixf-diagnose).

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
            name = "nixf-diagnose";
            text = ''
              shopt -s globstar

              flake_path="''${1}"

              ${getExe pkgs.nixf-diagnose} "''${flake_path}/"**/*.nix
            '';
          };
      }
    ];
  };

  imports = [
    (inputs.devshell.flakeModule or { })
  ];

  perSystem =
    { pkgs, ... }:
    {
      devshells.default = {
        packages = with pkgs; [ nixf-diagnose ];

        commands = [
          {
            name = "nixf-diagnose-all";
            help = "run nixf-diagnose";
            command = ''
              shopt -s globstar
              ${lib.getExe pkgs.nixf-diagnose} "''${PRJ_ROOT}"/**/*.nix
            '';
            category = "lint";
          }
        ];
      };
    };
}
