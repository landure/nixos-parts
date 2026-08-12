{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.presets.console;
in
{
  options.biapy.presets.console.enable = mkEnableOption "Console preset";

  config = mkIf cfg.enable {
    biapy = {
      console = {
        logs.enable = mkDefault true;
        media.enable = mkDefault true;
        network.enable = mkDefault true;
        office.enable = mkDefault true;
        systemd.enable = mkDefault true;
        text-editors.enable = mkDefault true;
      };

      programs = {
        eza.enable = mkDefault true;
        fzf.enable = mkDefault true;
        mcfly.enable = mkDefault true;
        mise.enable = mkDefault true;
        skim.enable = mkDefault true;
        ssh.enable = mkDefault true;
        zellij.enable = mkDefault true;
        zsh.enable = mkDefault true;
      };
    };
  };
}
