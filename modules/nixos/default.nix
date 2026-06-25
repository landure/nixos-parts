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
  flake = {
    modules.nixos = {
      default = config.flake.modules.nixos.biapy;
      biapy = inputs.import-tree ./_biapy;
    };

    nixosModules.biapy = config.flake.modules.nixos.biapy;

    tests = {
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
  };
}
