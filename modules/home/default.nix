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
    modules.home = {
      default = config.flake.modules.home.biapy;
      biapy = inputs.import-tree ./_biapy;
    };

    homeModules.biapy = config.flake.modules.home.biapy;

    tests = {
      "modules.home" = {
        "test: declares modules.home.biapy" = {
          expr = config.flake.modules.home ? biapy;
          expected = true;
        };

        "test: declares modules.home.default" = {
          expr = config.flake.modules.home ? default;
          expected = true;
        };
      };

      "homeModules.biapy" = {
        "test: declares flake.homeModules.biapy" = {
          expr = config.flake.homeModules ? biapy;
          expected = true;
        };
      };
    };
  };
}
