/**
  # NixOS WSL facter module

  ## 🛠️ Tech Stack

  - [NixOS WSL homepage](https://nix-community.github.io/NixOS-WSL/)
    ([NixOS WSL @ GitHub](https://github.com/nix-community/NixOS-WSL))..
*/
{ config, lib, ... }:
let
  inherit (config.hardware.facter) report;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.facter.detected.wsl;
in
{
  options.biapy.facter.detected.wsl.enable = mkEnableOption "Enable the Facter wsl module" // {
    default = "wsl" == report.virtualisation;
    defaultText = "hardware dependent";
  };

  config = mkIf cfg.enable {
    wsl = {
      enable = mkDefault true;
      # defaultUser = mkDefault (config.biapy.nixos-unified.nixos.main-user or "nixos");
    };
  };
}
