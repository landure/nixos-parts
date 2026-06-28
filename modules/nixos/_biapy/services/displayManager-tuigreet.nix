/**
  # greetd with tuigreet display manager

  ## 🛠️ Tech Stack

  - [tuigreet @ GitHub](https://github.com/apognu/tuigreet).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [services.greetd @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=services.greetd.)

  ## 🙇 Acknowledgements

  - [Greetd @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Greetd).
  - [Greetd @ NixOS Wiki](https://nixos.wiki/wiki/Greetd).
  - [greetd @ Arch Linux Wiki](https://wiki.archlinux.org/title/Greetd);
  - [Setting up greetd/tuigreet in NixOS with session detection and choosing (0.8.0 and 0.9.0) @ ~/ryjelsum](https://ryjelsum.me/homelab/greetd-session-choose/)
*/
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) getExe;
  inherit (lib.modules)
    mkDefault
    mkIf
    ;

  cfg = config.biapy.services.displayManager.tuigreet;
  desktopSessions = config.services.displayManager.sessionData.desktops;

  buildThemeOption =
    theme:
    lib.concatStrings (
      [ "'" ] ++ (lib.attrsets.mapAttrsToList (name: value: name + "=" + value + ";") theme) ++ [ "'" ]
    );

in
{
  options = {
    biapy.services.displayManager.tuigreet.enable = mkEnableOption "tuigreet greeter";
  };

  config = mkIf cfg.enable {
    # Add tuigreet to the system
    # environment.systemPackages = [ tuigreet ];

    # Configure greetd systemd service.
    services.greetd = {
      enable = mkDefault true;

      useTextGreeter = mkDefault true;

      # Define greetd settings
      settings = rec {
        # Define tuigreet greetd session
        tuigreet_session =

          {
            command = mkDefault (
              lib.concatStringsSep " " [
                (getExe pkgs.tuigreet)
                " --time" # display the current date and time
                " --remember" # remember last logged-in username
                " --remember-user-session" # remember last selected session for each user
                # @see https://ryjelsum.me/homelab/greetd-session-choose/
                " --sessions '${desktopSessions}/share/wayland-sessions'" # colon-separated list of Wayland session paths
                " --xsessions '${desktopSessions}/share/xsessions'" # colon-separated list of X11 session paths
                " --theme"
                (buildThemeOption {
                  border = "magenta";
                  text = "cyan";
                  prompt = "green";
                  time = "red";
                  action = "blue";
                  button = "yellow";
                  container = "black";
                  input = "red";
                })
              ]
            );
            # some tuigreet options are

            # --asterisks: display asterisks when a secret is typed
            # --theme THEME: define the application theme colors

            # Run with user greeter
            user = mkDefault "greeter";
          };

        # Set tuigreet_session as greetd default session
        default_session = mkDefault tuigreet_session;
      };
    };
  };
}
