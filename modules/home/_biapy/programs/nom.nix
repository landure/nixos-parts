/**
  # nom

  nom is a RSS reader for the terminal.

  The `nom` binary name clashes with `nix-output-monitor`, so the binary is
  installed as `nomrss` instead.

  ## 🛠️ Tech Stack

  - [nom @ GitHub](https://github.com/guyfedwards/nom)
    is a RSS reader for the terminal.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.nom @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/nom.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.biapy.programs.nom;
in
{
  options.biapy.programs.nom = {
    enable = mkEnableOption "nom RSS reader (installed as `nomrss`)";
    package = mkPackageOption pkgs "nom" { };
  };

  config = mkIf cfg.enable {
    programs.nom = {
      enable = mkDefault true;
      # `nom` clashes with nix-output-monitor, only ship the `nomrss` wrapper.
      # Plain `null`, not `mkDefault null`: Home Manager checks `package != null`.
      package = pkgs.writeShellApplication {
        name = "nomrss";
        text = ''
          exec ${getExe cfg.package} "''${@}"
        '';
      };
    };
  };
}
