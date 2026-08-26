/**
  # BCM43142 support

  ## 🛠️ Tech Stack

  - [Legacy Products @ Broadcom](https://www.broadcom.com/support/download-search?pg=Legacy%20Products&pf=Legacy%20Wireless&pn&pa&po&dk&pl).
  - [Broadcom Bluetooth firmware for Linux kernel @ GitHub](https://github.com/winterheart/broadcom-bt-firmware).
  - [broadcom-sta @ nixpkgs' GitHub](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/broadcom-sta/default.nix).

  ## 🙇 Acknowledgements

  - [drop broadcom-sta from nixos-factor-modules @ NixOS facter modules' GitHub](https://github.com/nix-community/nixos-facter-modules/commit/65446e98bc906dcc0906517d40a729d3ae30b289).
  - [NixOS install fails due to insecure Broadcom driver @ NixOS discourse](https://discourse.nixos.org/t/nixos-install-fails-due-to-insecure-broadcom-driver/67053).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) any elem optionals;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib.strings) optionalString;

  network_controllers = config.hardware.facter.report.hardware.network_controller or [ ];

  cfg = config.biapy.facter.detected.networking.broadcom;
in
{
  options.biapy.facter.detected.networking.broadcom = {
    full_mac.enable = mkEnableOption "Enable the Facter Broadcom Full MAC module" // {
      default = any (
        {
          vendor ? { },
          device ? { },
          ...
        }:
        # vendor (0x14e4) Broadcom Inc. and subsidiaries
        (vendor.value or 0) == 5348
        && (elem (device.value or 0) [
          17315 # 0x43a3
          17338 # 0x43ba
          17339 # 0x43bb
          17340 # 0x43bc
          17347 # 0x43c3
          17348 # 0x43c4
          17349 # 0x43c5
          17354 # 0x43ca
          17355 # 0x43cb
          17356 # 0x43cc
          17363 # 0x43d3
          17369 # 0x43d9
          17375 # 0x43df
          17385 # 0x43e9
          17388 # 0x43ec
          43602 # 0xaa52
        ])
      ) network_controllers;

      defaultText = "hardware dependent";
    };
    sta = {
      enable = mkEnableOption "Enable the Facter Broadcom STA module" // {
        default = any (
          {
            vendor ? { },
            device ? { },
            ...
          }:
          # vendor (0x14e4) Broadcom Inc. and subsidiaries
          (vendor.value or 0) == 5348
          && (elem (device.value or 0) [
            17169 # 0x4311
            17170 # 0x4312
            17171 # 0x4313
            17173 # 0x4315
            17191 # 0x4327
            17192 # 0x4328
            17193 # 0x4329
            17194 # 0x432a
            17195 # 0x432b
            17196 # 0x432c
            17197 # 0x432d
            17201 # 0x4331
            17235 # 0x4353
            17239 # 0x4357
            17240 # 0x4358
            17241 # 0x4359
            17253 # 0x4365
            17312 # 0x43a0
            17329 # 0x43b1
          ])
        ) network_controllers;

        defaultText = "hardware dependent";
      };

      bcm43142 = mkEnableOption "Enable the Facter Broadcom BCM43142 module" // {
        default = any (
          {
            vendor ? { },
            device ? { },
            ...
          }:
          # vendor (0x14e4) Broadcom Inc. and subsidiaries
          (vendor.value or 0) == 5348 && (device.value or 0) == 17253 # 0x4365
        ) network_controllers;

        defaultText = "hardware dependent";
      };
    };
  };

  config = mkIf cfg.sta.enable {
    hardware.firmware = with pkgs; [
      # Bluetooth
      broadcom-bt-firmware
    ];

    boot = {
      # add broadcom_sta module
      extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
      kernelModules = optionals cfg.sta.bcm43142 [ "wl" ];

      # blacklist modules to avoid collision with broadcom_sta
      blacklistedKernelModules = optionals cfg.sta.bcm43142 [
        "b43"
        "bcma"
      ];
    };

    # Use path-based naming for BCM43142
    services.udev.extraRules = optionalString (elem "wl" config.boot.kernelModules) ''
      # Broadcom BCM43142: Use path-based naming instead of eth0 fallback
      ACTION=="add", SUBSYSTEM=="net", DRIVERS=="wl", ENV{ID_NET_NAME_PATH}=="?*", NAME="$env{ID_NET_NAME_PATH}"
    '';

    # nixpkgs.config.permittedInsecurePackages = [ config.boot.kernelPackages.broadcom_sta.name ];
  };
}
