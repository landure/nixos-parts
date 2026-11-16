/**
  # nil

  nil is a Nix language server: an incremental analysis assistant for writing in Nix.

  ## 🛠️ Tech Stack

  - [nil @ GitHub](https://github.com/oxalica/nil).

  ## 📝 Documentation

  - [nil LSP Configuration @ GitHub](https://github.com/oxalica/nil/blob/main/docs/configuration.md).
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

  cfg = config.biapy.programs.nil;

  # The formatter nil delegates to when formatting on save.
  formatter = getExe config.biapy.programs.nixfmt-rs.package;
in
{
  options.biapy.programs.nil = {
    enable = mkEnableOption "nil, the Nix language server";
    package = mkPackageOption pkgs "nil" { };
  };

  config = mkIf cfg.enable {
    biapy.programs.nixfmt-rs.enable = mkDefault true;

    home.packages = [
      cfg.package
    ];

    programs = {
      opencode.settings.lsp.nil = mkDefault {
        command = [ (getExe cfg.package) ];
        extensions = [ ".nix" ];
        initialization.formatting.command = [
          formatter
          "-"
        ];
      };

      zed-editor = {
        userSettings = {
          languages.Nix.language_servers = mkDefault [
            "nixd"
            "nil"
          ];
          lsp.nil.initialization_options.formatting.command = mkDefault [
            formatter
            "-"
          ];
        };
      };
    };
  };
}
