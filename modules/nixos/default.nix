/**
  # flake-file base inputs

  ## 🛠️ Tech Stack

  - [flake-parts homepage](https://flake.parts/)
    ([flake-parts @ GitHub](https://github.com/hercules-ci/flake-parts)).
  - [flake-file homepage](https://flake-file.oeiuwq.com/)
    ([flake-file @ GitHub](https://github.com/vic/flake-file)).

  ## 📝 Documentation

  - [flake-parts.flakeModules @ flake-parts](https://flake.parts/options/flake-parts-flakemodules).

  ## 🙇 Acknowledgements

  - [Dendrix](https://dendrix.oeiuwq.com/index.html).
*/
{
  config,
  inputs,
  ...
}:
{
  imports = [
    (inputs.flake-parts.flakeModules.modules or { })
  ];

  flake.modules.nixos = {
    default = config.flake.modules.nixos.biapy;
    biapy = (inputs.import-tree ./biapy);
  };

  flake.nixosModules = config.flake.module.nixos;

  flake.tests = {
    "modules.nixos" = {
      "test: declares modules.nixos.biapy" = {
        expr = config.flake.modules.nixos ? biapy;
        expected = true;
      };

      "test: declares modules.nixos.default" = {
        expr = config.flake.modules.nixos ? default;
        expected = true;
      };
    };
  };

  perSystem =
    { inputs', ... }@args:
    {
      nix-unit= {
        inputs = inputs';
        tests = (import inputs.self.modules.nixos.biapy args).nix-unit.tests;
        };
    };
}
