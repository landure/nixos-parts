/**
  # AMD GPU

  ## 🛠️ Tech Stack

  - [amdgpu_top @ GitHub](https://github.com/Umio-Yasuno/amdgpu_top).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [hardware.facter @ NixOS reference](https://search.nixos.org/options?query=hardware.facter.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.hardware.amdgpu;

  amdgpu_available = config.hardware.facter.detected.graphics.amd.enable;
in
{
  options = {
    biapy.hardware.amdgpu.enable = mkEnableOption "harware tools (USB, PCI, Bluetooth)" // {
      default = amdgpu_available;
    };
  };

  config = mkIf cfg.enable {
    environment.defaultPackages = with pkgs; [ amdgpu_top ];
  };
}
