/**
  # NH

  NH is a modern helper utility that aims to consolidate and reimplement some
  of the commands and interfaces from various tools within the Nix/NixOS
  ecosystem.

  It aims to provide a cohesive,
  easily-understandable interface with more features, better ergonomics,
  and at many times better speed.

  ## 🛠️ Tech Stack

  - [NH @ GitHub](https://github.com/nix-community/nh).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.programs.nh;
in
{
  options = {
    biapy.programs.nh = {
      enable = mkEnableOption "NH";
    };
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = mkDefault true;

      clean = {
        enable = mkDefault true;
        dates = mkDefault "weekly";
        extraArgs = mkDefault "--keep 2 --keep-since 3d";
      };
    };
  };
}
