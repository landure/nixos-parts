/**
  # Well-known Nix cache subtituters configuration

  ## 🛠️ Tech Stack

  - [Nix Community](https://nix-community.org/).
  - [Flox](https://flox.dev/).
  - [devenv](https://devenv.sh/).

  ## 📝 Documentation

  - [Cache @ Nix Community](https://nix-community.org/cache/).
  - [Install Flox @ Flox](https://flox.dev/docs/install-flox/install/?h=substitu#__tabbed_1_6).
  - [Using devenv with Nix Flakes @ devenv](https://devenv.sh/guides/using-with-flakes/).

  ### ❄️ NixOS

  - [nix.settings.substituters @ NixOS reference](https://search.nixos.org/options?query=nix.settings.substituters).
  - [nix.settings.trusted-public-keys @ NixOS reference](https://search.nixos.org/options?query=nix.settings.trusted-public-keys).

  ## 🙇 Acknowledgements

  - [Binary Cache @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Binary_Cache).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.system.cache;
in
{
  options.biapy.system.cache.enable = mkEnableOption "Well-known Nix cache subtituters configuration";

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];

      trusted-substituters = [
        "https://hydra.nixos.org/"
        "https://devenv.cachix.org"
        "https://cache.flox.dev"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      ];
    };
  };
}
