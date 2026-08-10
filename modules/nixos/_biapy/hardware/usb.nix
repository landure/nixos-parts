/**
  # USB Tools

  ## 🛠️ Tech Stack

  - [Linux USB Project homepage](http://www.linux-usb.org/).
  - [cyme @ GitHub](https://github.com/tuna-f1sh/cyme).
  - [uhubctl @ GitHub](https://github.com/mvp/uhubctl).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [hardware.facter @ NixOS reference](https://search.nixos.org/options?query=hardware.facter.).

  ## 🙇 Acknowledgements

  - [uhubctl - Couper le courant d'un port USB en une commande @ Korben :fr:](https://korben.info/uhubctl-couper-alimentation-ports-usb.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) length;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.hardware.usb;
in
{
  options = {
    biapy.hardware.usb = {
      enable = mkEnableOption "USB" // {
        default = length (config.hardware.facter.report.hardware.usb or [ ]) > 0;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.defaultPackages = with pkgs; [
      usbutils
      cyme
      uhubctl
    ];
  };
}
