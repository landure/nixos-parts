/**
  # bat

  Bat is a modern cat clone.

  ## 🛠️ Tech Stack

  - [bat @ GitHub](https://github.com/sharkdp/bat).
  - [bat-extras @ GitHub](https://github.com/eth-p/bat-extras).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.bat](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable).

  ### 🎨 Stylix

  - [bat @ Stylix](https://nix-community.github.io/stylix/options/modules/bat.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.bat;

in
{
  options = {
    biapy.programs.bat = {
      enable = mkEnableOption "bat";
    };
  };

  config = mkIf cfg.enable {

    programs.bat = {
      enable = mkDefault true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
        pkgs.local.batline
      ];
    };

    #home.packages = with pkgs.local; [ batline ]
  };

}
