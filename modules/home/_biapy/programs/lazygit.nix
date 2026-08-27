/**
  # LazyGit

  ## 🛠️ Tech Stack

  - [LazyGit @ GitHub](https://github.com/jesseduffield/lazygit).

  ## 📝 Documentation

  ### 🏠 Home Manager Configuration Options

  - [programs.lazygit](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lazygit.enable).

  ### 🎨 Stylix

  - [LazyGit @ Stylix](https://nix-community.github.io/stylix/options/modules/lazygit.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.programs.lazygit;

in
{
  options.biapy.programs.lazygit.enable = mkEnableOption "LazyGit";

  config = mkIf cfg.enable {
    home.shellAliases = {
      lg = mkDefault "lazygit";
    };

    programs = {
      git.enable = mkDefault true;
      lazygit.enable = mkDefault true;
    };
  };
}
