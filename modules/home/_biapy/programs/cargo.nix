/**
  # Rust's cargo

  ## 🛠️ Tech Stack

  - [Rust homepage](https://www.rust-lang.org/).

  ## 📝 Documentation

  - [Configuration @ The Cargo book](https://doc.rust-lang.org/cargo/reference/config.html).

  ### 🏠 Home Manager

  - [programs.cargo @ NixOS reference](https://search.nixos.org/options?query=programs.cargo&source=home_manager).
  - [programs.cargo @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.cargo.enable).

  ## 🙇 Acknowledgements

  - [#17009: Tracking Issue for min-publish-age RFC 3923 @ cargo's GitHub](https://github.com/rust-lang/cargo/issues/17009).
*/
{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.cargo;
in
{
  options = {
    biapy.programs.cargo.enable = mkEnableOption "Rust's cargo";
  };

  config = mkIf cfg.enable {
    programs = {
      cargo = {
        enable = mkDefault true;
        settings = mkDefault { unstable.min-publish-age = mkOptionDefault true; };
      };
    };
  };
}
