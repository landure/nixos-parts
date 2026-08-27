/**
  # Jujutsu

  ## 🛠️ Tech Stack

  - [Jujutsu homepage](https://www.jj-vcs.dev/latest/)
    ([Jujutsu @ GitHub](https://www.jj-vcs.dev/latest/)).
  - [Jujutsu UI (jjui) homepage](https://idursun.github.io/jjui/)
    ([Jujutsu UI @ GitHub](https://github.com/idursun/jjui)).

  ## 📝 Documentation

  ### 🏠 Home Manager Configuration Options

  - [programs.jjui](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jjui.enable).
  - [programs.jjui @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.jjui.).
  - [programs.jujutsu](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jujutsu.enable).
  - [programs.jujutsu @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.jujutsu.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.programs.jujutsu;

in
{
  options.biapy.programs.jujutsu.enable = mkEnableOption "Git";

  config = mkIf cfg.enable {
    programs = {
      jujutsu.enable = mkDefault true;
      jjui.enable = mkDefault config.programs.jujutsu.enable;
    };
  };
}
