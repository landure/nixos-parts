/**
  # nixfmt-rs

  nixfmt-rs is a from-scratch Rust reimplementation of `nixfmt` that produces
  byte-identical output to the Haskell original.

  ## 🛠️ Tech Stack

  - [nixfmt-rs homepage](https://mic92.github.io/nixfmt-rs/)
    ([nixfmt-rs @ GitHub](https://github.com/Mic92/nixfmt-rs)).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.biapy.programs.nixfmt-rs;
in
{
  options.biapy.programs.nixfmt-rs = {
    enable = mkEnableOption "nixfmt-rs, the Nix formatter";
    package = mkPackageOption pkgs "nixfmt-rs" { };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    programs.zed-editor.userSettings.languages.Nix.formatter.external = {
      command = mkDefault "nixfmt";
      arguments = mkDefault [ ];
    };
  };
}
