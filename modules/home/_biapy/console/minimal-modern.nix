{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.console.minimal-modern;
in
{
  options.biapy.console.minimal-modern.enable = mkEnableOption "minimal modern console tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gawk
      sd
    ];

    biapy.programs = {
      bash.enable = mkDefault true;
      bat.enable = mkDefault true;
      fzf.enable = mkDefault true;
      starship.enable = mkDefault true;
      zellij.enable = mkDefault true;
    };

    programs = {
      fd.enable = mkDefault true;
      jq.enable = mkDefault true;
      ripgrep.enable = mkDefault true;
    };
  };
}
