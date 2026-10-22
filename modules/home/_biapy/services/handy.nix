/**
  # Handy

  Handy is a free, open source, and extensible speech-to-text application that
  works completely offline.

  ## 🛠️ Tech Stack

  - [Handy homepage](https://handy.computer/).
  - [Handy @ GitHub](https://github.com/cjpais/Handy).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [systemd.user.services @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/systemd.html#opt-systemd.user.services).
  - [systemd.user.services @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=systemd.user.services.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.biapy.services.handy;
in
{
  options.biapy.services.handy = {
    enable = mkEnableOption "Handy service";
    package = mkPackageOption pkgs.unstable "handy" { };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.wtype
    ];

    systemd.user.services.handy = {
      Unit = {
        Description = mkDefault "Handy speech-to-text service";
        Requires = [ "tray.target" ];
        After = mkDefault [
          "graphical-session.target"
          "tray.target"
        ];
        PartOf = mkDefault [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = mkDefault [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = mkDefault "${getExe cfg.package} --start-hidden";
        Restart = mkDefault "on-failure";
      };
    };

    wayland.windowManager = {
      hyprland.settings = {
      bind = [
        {
          _args = [
            "SUPER + SHIFT + period"
            # Using signals (recommended)
            (mkLuaInline "hl.dsp.exec_cmd(\"pkill -USR2 -x handy\")")
            # Using CLI flags
            # (mkLuaInline "hl.dsp.exec_cmd(\"handy --toggle-transcription\")")
          ];
        }
      ];
    };

    sway.config =
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
      {
        keybindings = {
          # Using signals (recommended)
          "${modifier}+Shift+period" = mkDefault "pkill -USR2 -x handy";
          # Using CLI flags
          # "${modifier}+Shift+period" = mkDefault "exec handy --toggle-transcription";
        };
      };
    };
  };
}
