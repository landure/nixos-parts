/**
  # Realtek rtw88

  ## 🛠️ Tech Stack

  - [Realtek rtw88 series WiFi 5 Linux drivers @ GitHub](https://github.com/lwfinger/rtw88).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [boot.extraModprobeConfig @ NixOS reference](https://search.nixos.org/options?query=boot.extraModprobeConfig).
  - [hardware.facter @ NixOS reference](https://search.nixos.org/options?query=hardware.facter.).
  - [networking.networkmanager.wifi.powersave @ NixOS reference](https://search.nixos.org/options?query=networking.networkmanager.wifi.powersave).

  ## 🙇 Acknowledgements

  - [Issue #61: firmware failed to leave lps state @ rtw88 GitHub](https://github.com/lwfinger/rtw88/issues/61).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.hardware.rtw88;

  network_controllers = config.hardware.facter.report.hardware.network_controller or [ ];
in
{
  options.biapy.facter.detected.networking.broadcom = {
    biapy.hardware.rtw88.enable = mkEnableOption "Enable the RTW88 module" // {

      default = lib.any (
        {
          vendor ? { },
          device ? { },
          ...
        }:
        # vendor (0x10ec) Realtek
        (vendor.value or 0) == 4332
        && (lib.elem (device.value or 0) [
          47138 # 0xb822 (Realtek Semiconductor Co., Ltd. RTL8822BE 802.11a/b/g/n/ac WiFi adapter)
        ])
      ) network_controllers;

      defaultText = "hardware dependent";
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.wifi.powersave = false;
    boot.extraModprobeConfig = ''
      options rtw88_core disable_lps_deep=y
      options rtw88_pci disable_msi=y disable_aspm=y
      options rtw_core disable_lps_deep=y
      options rtw_pci disable_msi=y disable_aspm=y
    '';
  };
}
