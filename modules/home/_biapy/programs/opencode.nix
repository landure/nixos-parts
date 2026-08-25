/**
  # OpenCode

  ## 🛠️ Tech Stack

  - [OpenCode homepage](https://opencode.ai/)
    ([OpenCode @ GitHub](https://github.com/anomalyco/opencode)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.opencode @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable).
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

  cfg = config.biapy.programs.opencode;

in
{
  options = {
    biapy.programs.opencode = {
      enable = mkEnableOption "opencode";
    };
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = mkDefault true;
      web.enable = mkDefault true;
      package = mkDefault pkgs.unstable.opencode;
    };
  };
}
