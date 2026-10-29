/**
  # LAN Mouse

  LAN Mouse is a cross-platform mouse and keyboard sharing software similar
  to universal-control on Apple devices.
  It allows for using multiple PCs via a single set of mouse and keyboard.
  This is also known as a Software KVM switch.

  ## 🛠️ Tech Stack

  - [LAN Mouse @ GitHub](https://github.com/feschber/lan-mouse).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.lan-mouse;
in
{
  options.biapy.programs.lan-mouse.enable = mkEnableOption "LAN Mouse";

  config = mkIf cfg.enable {

    programs.lan-mouse = {
      enable = mkDefault true;
      systemd = mkDefault true;
      # package = pkgs.lan-mouse.default
      # Optional configuration in nix syntax, see config.toml for available options
      # settings = { };
    };
  };
}
