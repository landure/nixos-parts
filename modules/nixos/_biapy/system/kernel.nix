/**
  # Linux Kernel

  ## 🛠️ Tech Stack

  - [Zen Kernel @ GitHub](https://github.com/zen-kernel/zen-kernel/wiki).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [boot.kernelPackages @ NixOS reference](https://search.nixos.org/options?query=boot.kernelPackages).

  ## 🙇 Acknowledgements

  - [Linux kernel @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Linux_kernel).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.system.kernel;
in
{
  options.biapy.system.kernel = {
    enable = mkEnableOption "Linux kernel custom configuration";
  };

  config = mkIf cfg.enable {
    boot.kernelPackages = mkDefault pkgs.linuxPackages_latest;

    # boot.extraModulePackages = with config.boot.kernelPackages; [ bbswitch ];
  };
}
