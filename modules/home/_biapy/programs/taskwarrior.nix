/**
  # Taskwarrior

  Taskwarrior is a command line task list management utility.

  ## 🛠️ Tech Stack

  - [Taskwarrior homepage](https://taskwarrior.org/)
    ([Taskwarrior @ GitHub](https://github.com/GothenburgBitFactory/taskwarrior)).
  - [taskwarrior-tui @ GitHub](https://github.com/kdheepak/taskwarrior-tui)
    is a terminal UI for Taskwarrior.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.taskwarrior @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/taskwarrior.html).
  - [programs.taskwarrior @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.taskwarrior.).

  ## 🙇 Acknowledgements

  - [Taskwarrior documentation](https://taskwarrior.org/docs/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.types) bool listOf str;

  cfg = config.biapy.programs.taskwarrior;
in
{
  options.biapy.programs.taskwarrior = {
    enable = mkEnableOption "Taskwarrior";

    package = mkPackageOption pkgs "taskwarrior3" { };

    withTui = mkOption {
      type = bool;
      default = true;
      description = "Install the taskwarrior-tui terminal user interface.";
    };

    # Tasks shown by default, one per project.
    projects = mkOption {
      type = listOf str;
      default = [ ];
      description = "Projects to show in the default task report.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ lib.optional cfg.withTui pkgs.taskwarrior-tui;

    programs.taskwarrior = {
      enable = mkDefault true;
      package = mkDefault cfg.package;

      colorTheme = mkDefault "dark-blue-256";

      config = {
        # Do not ask for confirmation before destructive operations.
        confirmation = mkDefault false;

        # Report columns.
        report = {
          minimal = {
            filter = mkDefault "status:pending";
            columns = mkDefault [
              "id"
              "priority"
              "project"
              "due"
              "description"
            ];
            labels = mkDefault [
              "ID"
              "Pri"
              "Project"
              "Due"
              "Description"
            ];
          };
        };

        # Default projects shown by `task next`.
        next = {
          projects = mkDefault (lib.concatStringsSep "," cfg.projects);
        };
      };
    };
  };
}
