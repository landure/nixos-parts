/**
  # Development environments

  ## 🛠️ Tech Stack

  - [devbox homepage](https://www.jetify.com/devbox)
    ([devbox @ GitHub](https://github.com/jetify-com/devbox))
  - [devenv homepage](https://devenv.sh/)
    ([devenv @ GitHub](https://github.com/cachix/devenv)).
  - [mise-en-place homepage](https://mise.jdx.dev/)
    ([mise-en-place @ GitHub](https://github.com/jdx/mise)).
  - [Development Containers homepage](https://containers.dev/).
    ([Dev Container CLI @ GitHub](https://github.com/devcontainers/cli)).

  ## 🙇 Acknowledgements

  - [Flox homepage](https://flox.dev/)
    ([Flox @ GitHub](https://github.com/flox/flox)).

*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.dev.dev-environments;
in
{
  options = {
    biapy.dev.dev-environments = {
      enable = mkEnableOption "development environments";
    };
  };

  config = mkIf cfg.enable {
    biapy.programs.mise.enable = mkDefault true;

    home.packages = with pkgs; [
      # Development environments
      devbox
      devenv
      devcontainer
      flox
    ];
  };

}
