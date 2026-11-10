/**
  # rbw

  rbw is an unofficial command line client for Bitwarden.

  ## 🛠️ Tech Stack

  - [rbw @ GitHub](https://github.com/doy/rbw).

  ## 🙇 Acknowledgements

  ### 🏠 Home Manager

  - [programs.rbw @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rbw.enable).
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

  cfg = config.biapy.programs.rbw;
in
{
  options.biapy.programs.rbw.enable = mkEnableOption "rbw, a CLI Bitwarden client";

  config = mkIf cfg.enable {
    programs.rbw = {
      enable = mkDefault true;

      # `settings` is a `nullOr` submodule upstream, so the account email has
      # to be provided here rather than defaulted in its own option.
      settings = mkDefault {
        email = mkDefault config.biapy.user.identity.email;
        base_url = mkDefault "https://vaultwarden.biapy.fr/";
        pinentry = mkDefault pkgs.pinentry-gnome3;
      };
    };
  };
}
