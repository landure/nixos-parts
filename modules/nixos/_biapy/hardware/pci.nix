/**
  # PCI tools

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
  inherit (config.hardware.facter) report;
  inherit (lib.lists) length;

  cfg = config.biapy.hardware.pci;

  pci_available = length (report.hardware.pci or [ ]) > 0;
in
{
  options = {
    biapy.hardware.pci.enable = mkEnableOption "PCI tools" // {
      default = pci_available;
    };
  };

  config = mkIf cfg.enable {
    environment.defaultPackages = with pkgs; [
      pciutils
    ];
  };
}
