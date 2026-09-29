/**
  # KeePassXC

  ## 🛠️ Tech Stack

  - [KeePassXC @ homepage](https://keepassxc.org/)
    ([KeePassXC @ GitHub](https://github.com/keepassxreboot/keepassxc))
    is an offline, cross-platform password manager with
    a `keepassxc-cli(1)` companion.
  - [kpcli homepage](http://kpcli.sourceforge.net)
    is a command-line interface for KeePass databases.
  - [git-credential-keepassxc @ GitHub](https://github.com/FarisHijazi/git-credential-keepassxc)
    is a git credential helper backed by KeePassXC.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.git-credential-keepassxc @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git-credential-keepassxc.enable).
  - [programs.git-credential-keepassxc @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.git-credential-keepassxc.).
  - [programs.keepassxc @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.keepassxc.enable).
  - [programs.keepassxc @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.keepassxc.).
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

  cfg = config.biapy.programs.keepassxc;
in
{
  options.biapy.programs.keepassxc.enable = mkEnableOption "KeePassXC";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kpcli # CLI for KeePass databases.
    ];

    programs = {
      # KeePassXC — offline password manager with a CLI
      # companion (`keepassxc-cli`) and git credential helper.
      keepassxc.enable = mkDefault true;

      # git-credential-keepassxc — fetch git credentials
      # directly from a KeePassXC database.
      git-credential-keepassxc.enable = mkDefault config.programs.git.enable;
    };
  };
}
