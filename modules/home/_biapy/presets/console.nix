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
        cheatsheets.enable = mkDefault true;
        files.enable = mkDefault true;
        graphics.enable = mkDefault true;
        logs.enable = mkDefault true;
        media.enable = mkDefault true;
        monitoring.enable = mkDefault true;
        network.enable = mkDefault true;
        office.enable = mkDefault true;
        systemd.enable = mkDefault true;
        text-editors.enable = mkDefault true;
        ux.enable = mkDefault true;
      };

      programs = {
        bash.enable = mkDefault true;
        fzf.enable = mkDefault true;
        mise.enable = mkDefault true;
        nh.enable = mkDefault true;
        skim.enable = mkDefault true;
        ssh.enable = mkDefault true;
        tirith.enable = mkDefault false;
        zsh.enable = mkDefault true;
      };
    };
  };
}
