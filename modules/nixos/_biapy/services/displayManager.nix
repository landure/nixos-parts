/**
  # Display managers

  ## 🛠️ Tech Stack

  - [cosmic-greeter @ GitHub](https://github.com/pop-os/cosmic-greeter).
  - [DankGreet (dms-greeter) @ DankLinux](https://danklinux.com/docs/dankgreeter/)
    ([Dank (dms) Greeter @ GitHub](https://github.com/AvengeMedia/DankMaterialShell/tree/master/quickshell/Modules/Greetd)).
  - [GDM - GNOME Display Manager @ GNOME's GitLab](https://gitlab.gnome.org/GNOME/gdm).
  - [lemurs @ GitHub](https://github.com/coastalwhite/lemurs).
  - [LightDM Display Manager @ GitHub](https://github.com/canonical/lightdm).
  - [ly @ Codeberg](https://codeberg.org/fairyglade/ly).
  - [ReGreet @ GitHub](https://github.com/rharish101/ReGreet).
  - [Cage homepage](https://www.hjdskes.nl/projects/cage/)
    ([Cage @ GitHub](https://github.com/cage-kiosk/cage)).
  - [Simple Desktop Display Manager (SDDM) @ GitHub](https://github.com/sddm/sddm).
  - [tuigreet @ GitHub](https://github.com/apognu/tuigreet).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.displayManager.cosmic-greeter @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.cosmic-greeter.)
  - [services.displayManager.dms-greeter @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.dms-greeter.)
  - [services.displayManager.gdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.gdm.)
  - [services.displayManager.lemurs @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.lemurs.)
  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.lightdm.)
  - [services.displayManager.sddm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.sddm.)
  - [services.greetd @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.greetd.)

  ### 🎨 Stylix

  - [GNOME @ Stylix](https://nix-community.github.io/stylix/options/modules/gnome.html).
  - [LightDM @ Stylix](https://nix-community.github.io/stylix/options/modules/lightdm.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;
  inherit (lib.modules)
    mkDefault
    mkIf
    ;

  cfg = config.biapy.services.displayManager;
in
{
  options = {
    biapy.services.displayManager = {
      enable = mkEnableOption "display manager";

      type = mkOption {
        type = enum [
          "cosmic-greeter"
          "gdm"
          "lemurs"
          "lightdm"
          "ly"
          "regreet"
          "sddm"
          "tuigreet"
        ];
        default = "lemurs";
        description = ''
          What display manager to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    biapy.services.displayManager = {
      ly.enable = mkDefault (cfg.type == "ly");
      regreet.enable = mkDefault (cfg.type == "regreet");
      tuigreet.enable = mkDefault (cfg.type == "tuigreet");
    };

    services.displayManager = {
      cosmic-greeter.enable = mkDefault (cfg.type == "cosmic-greeter");
      gdm.enable = mkDefault (cfg.type == "gdm");
      lemurs.enable = mkDefault (cfg.type == "lemurs");
      sddm.enable = mkDefault (cfg.type == "sddm");
    };
  };
}
