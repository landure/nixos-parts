/**
  # Rofi

  Rofi is a window switcher, application launcher and dmenu replacement.

  ## 🛠️ Tech Stack

  - [Rofi homepage](https://davatorium.github.io/rofi/)
    ([Rofi @ GitHub](https://github.com/davatorium/rofi)).
  - [rofi-emoji @ GitHub](https://github.com/Mange/rofi-emoji).
  - [rofi-systemd @ GitHub](https://github.com/colonelpanic8/rofi-systemd).
  - [🛜 Rofi Network Manager @ GitHub](https://github.com/meowrch/rofi-network-manager).
  - [rbw-rofi @ GitHub](https://github.com/fdw/rofi-rbw).
  - [rofi-bluetooth @ GitHub](https://github.com/nickclyde/rofi-bluetooth).
  - [Keepmenu @ GitHub](https://github.com/firecat53/keepmenu).
  - [wtype @ GitHub](https://github.com/atx/wtype).
  - [xdotool @ GitHub](https://github.com/jordansissel/xdotool).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.rofi @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/rofi.html).
  - [programs.rofi @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.rofi.).

  ### 🎨 Stylix

  - [Rofi @ Stylix](https://nix-community.github.io/stylix/options/modules/rofi.html).

  ## 🙇 Acknowledgements

  - [Rofi @ ArchLinux Wiki](https://wiki.archlinux.org/title/Rofi).
  - [Rofi custom Applets, Launchers & Powermenus](https://github.com/adi1090x/rofi).
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
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.rofi;
in
{
  options.biapy.programs.rofi.enable = mkEnableOption "Rofi";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotool
      # wtype, xdotool, ydotool
      wl-clipboard-rs
    ];

    programs.rofi = {
      enable = mkDefault true;
      # package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; }

      # cycle through the results list.
      # cycle = false

      extraConfig = {
        #   kb-primary-paste = "Control+V,Shift+Insert";
        #   kb-secondary-paste = "Control+v,Insert";
        combi-modes = mkDefault "drun,run,ssh,window";
      };

      # Modes to enable. For custom modes see man 5 rofi-script.
      modes = mkDefault [
        "drun"
        "ssh"
        "window"
        # "windowcd"
        "run"
        "combi"
        # "keys"
        # "filebrowser"
        # "recursivebrowser"
        {
          name = "emoji";
          path = "${pkgs.rofi-emoji}/lib/rofi";
        }
        {
          name = "rbw";
          path = getExe pkgs.rofi-rbw;
        }
        {
          name = "nm";
          path = getExe pkgs.rofi-network-manager;
        }
        #{
        #  name = "systemd";
        #  path = lib.getExe pkgs.rofi-systemd;
        #}
        #{
        #  name = "calc";
        #  path = lib.getExe pkgs.rofi-calc;
        #}
      ];

      # enable rofi integration with password-store.
      pass.enable = mkDefault config.programs.password-store.enable;

      # List of rofi plugins to be installed.
      plugins = with pkgs; [
        #rofi-calc
        #rofi-systemd
        rofi-network-manager
        rofi-emoji
        rofi-rbw
      ];

      # Path to the terminal which will be used to run console applications
      terminal = mkDefault config.biapy.desktop.terminalEmulators.default;
    };

    # stylix.targets.rofi.enable = config.stylix.autoEnable;

    wayland.windowManager.sway.config.menu = lib.concatStringsSep " " [
      (lib.meta.getExe config.programs.rofi.finalPackage)
      "-show"
      "combi"
      "-show-icons"
    ];
  };
}
