/**
  # statix

  ## 🛠️ Tech Stack

  - [statix @ GitHub](https://github.com/oppiliappan/statix).

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
            name = "statix-check";
            text = "${getExe pkgs.statix} check";
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
        packages = with pkgs; [ statix ];

        commands = [
          {
            name = "statix-check";
            help = "Lint nix files with statix";
            command = "${getExe pkgs.statix} check";
            category = "lint";
          }
        ];
      };
    };
}
