/**
  # Pay Respects

  Pay Respects suggests a fix to wrong console commands by pressing `F`.

  ## 🛠️ Tech Stack

  - [nix-index @ GitHub](https://github.com/nix-community/nix-index).
  - [Pay Respects @ Codeberg](https://codeberg.org/iff/pay-respects).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.pay-respects @ Home Manager Documentation](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pay-respects.enable).
  - [programs.pay-respects @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.pay-respects.).
*/
{ config, inputs, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.pay-respects;
in
{
  imports = [
    inputs.biapy-parts.inputs.nix-index-database.homeModules.default
  ];

  options = {
    biapy.programs.pay-respects = {
      enable = mkEnableOption "mise";
    };
  };

  config = mkIf cfg.enable {
    # pay-respects ease fixing erroneous commands.
    programs = {
      # Payrespects require nix-locate or nix-search-cli
      nix-index.enable = mkDefault true;

      # Install comma runner (, some-command).
      nix-index-database.comma.enable = mkDefault true;

      pay-respects = {
        enable = mkDefault true;
        options = mkDefault [
          "--alias"
          "f"
        ];

        rules = mkDefault {
          cargo = {
            command = "cargo";
            match_err = [
              {
                pattern = [ "run `cargo init` to initialize a new rust project" ];
                suggest = [ "cargo init" ];
              }
            ];
          };

          _PR_GENERAL = {
            match_err = [
              {
                pattern = [ "permission denied" ];
                suggest = [
                  "#[executable(sudo), !cmd_contains(sudo)]\nsudo {{command}}"
                ];
              }
            ];
          };
        };
      };
    };
  };
}
