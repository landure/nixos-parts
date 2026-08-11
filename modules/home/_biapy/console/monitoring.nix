/**
  # Processes and monitoring tools

  ## 🛠️ Tech Stack

  - [BTOP++ @ GitHub](https://github.com/aristocratos/btop).
  - [bottom homepage](https://bottom.pages.dev/)
    ([bottom @ GitHub](https://github.com/ClementTsang/bottom)).
  - [dool @ GitHub](https://github.com/scottchiefbaker/dool).
  - [inxi homepage](https://smxi.org/docs/inxi.htm)
    ([inxi @ Codeberg](https://codeberg.org/smxi/inxi)).
  - [iotop @ GitHub](https://github.com/Tomas-M/iotop).
  - [procs @ GitHub](https://github.com/dalance/procs).
  - [witr playground](https://pranshuparmar.github.io/witr/)
    ([witr @ GitHub](https://github.com/pranshuparmar/witr)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.btop @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.btop.enable).
  - [programs.bottom @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bottom.enable).

  ### 🎨 Stylix

  - [btop @ Stylix](https://nix-community.github.io/stylix/options/modules/btop.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.console.monitoring;
in
{
  options = {
    biapy.console.monitoring = {
      enable = mkEnableOption "monitoring TUI tools";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      dool
      inxi
      iotop
      procs # ps alternative
      witr # why is it running.
    ];

    programs = {
      btop.enable = mkDefault true;
      bottom.enable = mkDefault true;
    };
  };
}
