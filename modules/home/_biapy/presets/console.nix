{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.presets.console;
in
{
  options.biapy.presets.console.enable = mkEnableOption "Console preset";

  config = mkIf cfg.enable {
    biapy.programs.mise.enable = mkDefault true;
    biapy.programs.fzf.enable = mkDefault true;
    biapy.programs.eza.enable = mkDefault true;
    biapy.programs.ssh.enable = mkDefault true;
    biapy.programs.skim.enable = mkDefault true;
    biapy.programs.zed.enable = mkDefault true;
    biapy.programs.zsh.enable = mkDefault true;
  };
}
