/**
  # Processes and monitoring tools

  ## 🛠️ Tech Stack

  - [BTOP++ @ GitHub](https://github.com/aristocratos/btop).
  - [bottom homepage](https://bottom.pages.dev/)
    ([bottom @ GitHub](https://github.com/ClementTsang/bottom)).
  - [dool @ GitHub](https://github.com/scottchiefbaker/dool)
    monitors many aspects of a Linux system: CPU, Memory, Network, …
  - [inxi homepage](https://smxi.org/docs/inxi.htm)
    ([inxi @ Codeberg](https://codeberg.org/smxi/inxi)).
  - [iotop @ GitHub](https://github.com/Tomas-M/iotop)
    is a top utility for IO.
  - [procs @ GitHub](https://github.com/dalance/procs)
    is a modern replacement for ps written in Rust.
  - [ramfetch @ Codeberg](https://codeberg.org/jahway603/ramfetch).
    is a fetch which displays memory info using `/proc/meminfo`.
  - [witr playground](https://pranshuparmar.github.io/witr/)
    ([witr @ GitHub](https://github.com/pranshuparmar/witr))
    trace any process, port, container, or file back to what started it.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.btop @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.btop.enable).
  - [programs.btop @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.btop.).
  - [programs.bottom @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bottom.enable).
  - [programs.bottom @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.bottom.).

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
      ramfetch
      witr # why is it running.
    ];

    biapy.programs = {
      fastfetch.enable = mkDefault true;
    };

    programs = {
      btop.enable = mkDefault true;
      bottom.enable = mkDefault true;
    };
  };
}
