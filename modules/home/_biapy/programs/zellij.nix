/**
  # Zellij

  Zellij is a workspace aimed at developers, ops-oriented people,
  and anyone who loves the terminal.
  Similar programs are sometimes called "Terminal Multiplexers".

  ## 🛠️ Tech Stack

  - [Zellij homepage](https://zellij.dev/).
    ([Zellij @ GitHub](https://github.com/zellij-org/zellij)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.zellij @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/zellij.html).
  - [programs.zellij @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.zellij.).

  ### 🎨 Stylix

  - [Zellij @ Stylix](https://nix-community.github.io/stylix/options/modules/zellij.html).

  ## 🙇 Acknowledgements

  - [Zellij documentation](https://zellij.dev/documentation/).
  - [Zellij default keybindings](https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kdl).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.zellij;
in
{
  options.biapy.programs.zellij.enable = mkEnableOption "Zellij terminal multiplexer";

  config = mkIf cfg.enable {
    # Zellij is a terminal multiplexer
    programs.zellij = {
      enable = mkDefault true;

      attachExistingSession = mkDefault false;
      exitShellOnExit = mkDefault true;

      settings = {
        # @see https://zellij.dev/documentation/options
        show_startup_tips = mkDefault false;
        show_release_notes = mkDefault false;

        keybinds = mkDefault {
          _children = [
            { unbind = "Ctrl q"; }
            {
              shared_except = {
                _args = [ "locked" ];
                _children = [
                  {
                    bind = {
                      _args = [ "Ctrl Alt Shift q" ];
                      _children = [ { Quit = { }; } ];
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };
}
