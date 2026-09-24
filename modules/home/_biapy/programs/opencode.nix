/**
  # OpenCode

  ## 🛠️ Tech Stack

  - [OpenCode homepage](https://opencode.ai/)
    ([OpenCode @ GitHub](https://github.com/anomalyco/opencode)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.opencode @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable).
  - [programs.opencode @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.opencode.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr path;

  cfg = config.biapy.programs.opencode;

in
{
  options.biapy.programs.opencode = {
    enable = mkEnableOption "opencode";
    web.environmentFile = mkOption {
      type = nullOr path;
      default = null;
      example = "/run/secrets/opencode-web";
      description = ''
        Path to a file containing environment variables for the opencode web
        service, in the format of an EnvironmentFile as described by
        {manpage}`systemd.exec(5)` (i.e. `KEY=VALUE` pairs, one per line).

        This is the recommended way to set `OPENCODE_SERVER_PASSWORD` without
        exposing the secret value in the Nix store.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = mkDefault true;
      web = {
        enable = mkDefault (builtins.isPath cfg.web.environmentFile);
        environmentFile = mkDefault cfg.web.environmentFile;
      };
      enableMcpIntegration = mkDefault true;
      package = mkDefault pkgs.unstable.opencode;
    };
  };
}
