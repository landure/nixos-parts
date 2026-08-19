/**
  # Flyline

  Flyline is a Bash plugin to replace readline for a modern line editing
  experience: syntax highlighting, agent integration, rich prompts,
  tooltips, fuzzy history search, and more!

  ## 🛠️ Tech Stack

  - [Flyline @ GitHub](https://github.com/HalFrgrd/flyline)
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
  inherit (lib.types) package;

  cfg = config.biapy.programs.flyline;

  defaultPackage = pkgs.local.flyline;
  libraryName = "libflyline${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}";
in
{
  options.biapy.programs.flyline = {
    enable = mkEnableOption "flyline integration into bash shell";

    package = mkOption {
      type = package;
      default = defaultPackage;
      description = "The flyline package to load into Bash.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.bash.initExtra = mkDefault ''
      enable -f '${cfg.package}/lib/${libraryName}' 'flyline'
    '';
  };
}
