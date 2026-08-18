{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.presets.dev;
in
{
  options.biapy.presets.dev.enable = mkEnableOption "software development preset";

  config = mkIf cfg.enable {
    biapy.dev = {
      containers.enable = mkDefault true;
      dev-environments.enable = mkDefault true;
      diff.enable = mkDefault true;
      k8s.enable = mkDefault true;
      nix.enable = mkDefault true;
    };
  };
}
