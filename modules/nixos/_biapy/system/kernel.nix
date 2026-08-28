/**
  # Linux Kernel

  ## 🛠️ Tech Stack

  - [Zen Kernel @ GitHub](https://github.com/zen-kernel/zen-kernel/wiki).
  - [XanMod homepage](https://xanmod.org/)
    ([XanMod @ GitLab](https://gitlab.com/xanmod/linux)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [boot.kernelPackages @ NixOS reference](https://search.nixos.org/options?query=boot.kernelPackages).
  - [linuxKernel.kernels @ NixOS reference](https://search.nixos.org/packages?query=linuxKernel.kernels.)

  ## 🙇 Acknowledgements

  - [Linux kernel @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Linux_kernel).
  - [Kernel @ ArchLinux Wiki](https://wiki.archlinux.org/title/Kernel).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) attrNames;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) enum;

  cfg = config.biapy.system.kernel;

  kernels = with pkgs; {
    default = linuxPackages;
    latest = linuxPackages_latest;
    zen = linuxPackages_zen;
    xanmod = linuxPackages_xanmod;
    xanmod_latest = linuxPackages_xanmod_latest;
    xanmod_stable = linuxPackages_xanmod_stable;
  };
in
{
  options.biapy.system.kernel = {
    enable = mkEnableOption "Linux kernel custom configuration";

    build = mkOption {
      type = enum (attrNames kernels);
      default = "zen";
      description = "Kernel build to use";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelPackages = mkDefault (kernels.${cfg.build} or pkgs.linuxPackages);

    # boot.extraModulePackages = with config.boot.kernelPackages; [ bbswitch ];
  };
}
