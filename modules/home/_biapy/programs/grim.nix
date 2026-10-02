/**
  # Grim

  Grim is a screenshot tool for Wayland that captures images from a Wayland
  compositor. Slurp is a tool to select a region in a Wayland compositor.

  ## 🛠️ Tech Stack

  - [grim @ sourcehut](https://sr.ht/~emersion/grim/)
    grab images from a Wayland compositor.
  - [slurp @ GitHub](https://github.com/emersion/slurp)
    selects a region in a Wayland compositor and print it to the standard output.

  ## 🙇 Acknowledgements

  - [Sway @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Sway).
  - [Screen capture @ Arch Linux Wiki](https://wiki.archlinux.org/title/Screen_capture).
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

  cfg = config.biapy.programs.grim;
in
{
  options.biapy.programs.grim.enable = mkEnableOption "Grim and Slurp screenshot tools";

  config = mkIf cfg.enable {
    home.shellAliases = {
      fullshot = mkDefault ''grim - | tee "$(xdg-user-dir 'PICTURES')/Screenshots/screenchot-$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy'';
      shot = mkDefault ''slurp | grim -g- - | tee "$(xdg-user-dir 'PICTURES')/Screenshots/screenchot-$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy'';
    };

    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard-rs
    ];

    wayland.windowManager.sway.config.keybindings = mkIf (!config.biapy.services.flameshot.enable) (
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
      {
        # Manual screenshot GUI that saves to clipboard and closes on selection.
        # Screenshot a selection that saves to ~/Screenshots and copies to clipboard.
        "${modifier}+Shift+s" =
          mkDefault ''exec selection="$(slurp)" && grim -g "''${selection}" - | tee "$(xdg-user-dir 'PICTURES')/Screenshots/screenchot-$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy'';
        # Screenshot the currently focused screen, save to ~/Screenshots and copy to clipboard.
        # "Print" =
        #  ''exec grimshot save output - | tee "$(xdg-user-dir 'PICTURES')/Screenshots/screenchot-$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy'';
      }
    );
  };
}
