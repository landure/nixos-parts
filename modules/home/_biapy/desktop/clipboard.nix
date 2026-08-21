/**
  # Wayland clipboard tools

  ## 🛠️ Tech Stack

  - [clipcat @ GitHub](https://github.com/xrelkd/clipcat)
    is a clipboard manager written in Rust Programming Language.
  - [cliphist @ GitHub](https://github.com/sentriz/cliphist)
    is a Wayland clipboard manager with support for multimedia.
  - [clipman @ GitHub](https://github.com/chmouel/clipman)
    is a basic clipboard manager for Wayland,
    with support for persisting copy buffers after an application exits.
  - [clipmenu @ GitHub](https://github.com/cdown/clipmenu)
    is a simple clipboard manager using dmenu, rofi or similar.
  - [clipse @ GitHub](https://github.com/savedra1/clipse)
    is a configurable TUI clipboard manager for Unix.
  - [CopyQ homepage](https://hluk.github.io/CopyQ)
    ([CopyQ @ GitHub](https://github.com/hluk/CopyQ))
    is an advanced clipboard manager with editing and scripting features.
  - [wl-clip-persist @ GitHub](https://github.com/Linus789/wl-clip-persist).
    keeps Wayland clipboard even after programs close
  - [wl-clipboard-rs @ GitHub](https://github.com/YaLTeR/wl-clipboard-rs)
    is a safe Rust crate for working with the Wayland clipboard.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [services.clipcat @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.clipcat.enable).
  - [services.clipcat @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.clipcat.).
  - [services.cliphist @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.cliphist.enable).
  - [services.cliphist @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.cliphist.).
  - [services.clipman @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.clipman.enable).
  - [services.clipman @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.clipman.).
  - [services.clipmenu @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.clipmenu.enable).
  - [services.clipmenu @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.clipmenu.).
  - [services.clipse @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.clipse.enable).
  - [services.clipse @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.clipse.).
  - [services.copyq @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.copyq.enable).
  - [services.copyq @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.copyq.).
  - [services.wl-clip-persist @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-services.wl-clip-persist.enable).
  - [services.wl-clip-persist @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=services.wl-clip-persist.).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) toString;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum int package;

  cfg = config.biapy.desktop.clipboard;

  history_tools = [
    "wl-clip-persist"
    "clipse"
    "clipmenu"
    "clipman"
    "cliphist"
    "clipcat"
    "copyq"

  ];

in
{
  options = {
    biapy.desktop.clipboard = {
      enable = mkEnableOption "Wayland clipboard tools";

      package = mkOption {
        type = package;
        default = pkgs.wl-clipboard-rs;
        description = "The wl-clipboard package to use.";
      };

      history = {
        enable = mkEnableOption "Clipboard history";
        tool = mkOption {
          type = enum history_tools;
          default = "cliphist";
          description = "The clipboard history service to use.";
        };

        size = lib.mkOption {
          type = int;
          default = 100;
          description = "Number of clipboard history lines to keep.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
    ];
    services = {
      clipcat = {
        enable = mkDefault (cfg.history.tool == "clipcat");
        daemonSetting = {
          daemonize = true;
          max_history = cfg.history.size;
        };
        menuSettings = {
          finder = "rofi";
          rofi = {
            line_length = 100;
            menu_length = 30;
            menu_prompt = "Clipcat";
            extra_arguments = [
              "-mesg"
              "Please select a clip"
            ];
          };
          dmenu = {
            line_length = 100;
            menu_length = 30;
            menu_prompt = "Clipcat";
          };
        };
      };
      cliphist = {
        enable = mkDefault (cfg.history.tool == "cliphist");
        clipboardPackage = mkDefault cfg.package;
        extraOptions = [
          "-max-dedupe-search"
          "10"
          "-max-items"
          (toString cfg.history.size)
        ];

      };
      clipman = {
        enable = mkDefault (cfg.history.tool == "clipman");
        extraArgs = [
          "--max-items"
          (toString cfg.history.size)
        ];
      };
      clipmenu = {
        enable = mkDefault (cfg.history.tool == "clipmenu");
        launcher = "rofi";
      };
      clipse = {
        enable = mkDefault (cfg.history.tool == "clipse");
        historySize = mkDefault cfg.history.size;
        imageDisplay.type = mkDefault "kitty";
      };
      copyq = {
        enable = mkDefault (cfg.history.tool == "copyq");
        forceXWayland = mkDefault true;
      };
      wl-clip-persist = {
        enable = mkDefault (cfg.history.tool == "wl-clip-persist");
        extraOptions = [
          "--write-timeout"
          "1000"
          "--ignore-event-on-error"
          "--all-mime-type-regex"
          "'(?i)^(?!image/).+'"
          "--selection-size-limit"
          "1048576"
        ];
      };
    };
  };
}
