/**
  ## Fastfetch

  A maintained, feature-rich and performance oriented,
  neofetch like system information tool.

  ## 🛠️ Tech Stack

  - [Fastfetch @ GitHub](https://github.com/fastfetch-cli/fastfetch).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.fastfetch @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fastfetch.enable).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.fastfetch;
in
{
  options = {
    biapy.programs.fastfetch.enable = mkEnableOption "fastfetch";
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = mkDefault true;
      # settings = {
      #   logo = {
      #     source = "nixos_small";
      #     padding = {
      #       right = 1;
      #     };
      #   };
      #   display = {
      #     size = {
      #       binaryPrefix = "si";
      #     };
      #     color = "blue";
      #     separator = "  ";
      #   };
      #   modules = [
      #     {
      #       type = "datetime";
      #       key = "Date";
      #       format = "{1}-{3}-{11}";
      #     }
      #     {
      #       type = "datetime";
      #       key = "Time";
      #       format = "{14}:{17}:{20}";
      #     }
      #     "break"
      #     "player"
      #     "media"
      #   ];
      # };
    };
  };
}
