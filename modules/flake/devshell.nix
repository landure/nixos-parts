/**
  # devshell

  ## 🛠️ Tech Stack

  - [devshell homepage](https://numtide.github.io/devshell/)
    ([devshell @ GitHub](https://github.com/numtide/devshell)).
  - [flake-parts homepage](https://flake.parts/)
    ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).
*/
{ inputs, lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  flake-file.inputs = {
    devshell.url = mkDefault "github:numtide/devshell";
  };

  imports = [
    (inputs.devshell.flakeModule or { })
  ];

  perSystem =
    { pkgs, ... }:
    {
      devshells.default = {
        commands = [
          {
            package = pkgs.nixfmt-tree;
            category = "formatter";
          }
        ];
      };
    };
}
