/**
  Automatically run the garbage collector at a specific time.

  ## 📝 Documentation

  ### ❄️ NixOS

  - [nix.optimise @ NixOS reference](https://search.nixos.org/options?query=nix.optimise).
  - [nix.gc @ NixOS reference](https://search.nixos.org/options?query=nix.gc).

  ## 🙇 Acknowledgements

  - [Storage optimization @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Storage_optimization).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.system.nix-sane-defaults;
in
{
  options.biapy.nix-sane-defaults.enable = mkEnableOption "Sane Defaults";

  config = mkIf cfg.enable {
    biapy.programs.nh.enable = mkDefault true;

    nix = {
      # Automatically run the nix store optimiser
      optimise = {
        automatic = mkDefault true;
        # Optional; allows customizing optimisation schedule
        # dates = [ "03:45" ];
      };

      gc = {
        automatic = mkDefault true;
        # dates = mkDefault "weekly";
        options = mkDefault "--delete-older-than 7d";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Optimise the store during every build. This might slow down build.
        auto-optimise-store = mkDefault true;
      };
    };
  };
}
