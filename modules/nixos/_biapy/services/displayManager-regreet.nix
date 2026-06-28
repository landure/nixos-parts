/**
  # regreet display manager

  ## 🛠️ Tech Stack

  - [ReGreet @ GitHub](https://github.com/rharish101/ReGreet).
  - [Cage homepage](https://www.hjdskes.nl/projects/cage/)
    ([Cage @ GitHub](https://github.com/cage-kiosk/cage)).

  ## 📝 Documentation

  ### ❄️ NixOS

  - [programs.regreet @ NixOS reference](https://search.nixos.org/options?&query=services.displayManager.  - [services.displayManager.lightdm @ NixOS reference](https://search.nixos.org/options?&query=programs.regreet.)

  ### 🎨 Stylix

  - [ReGreet @ Stylix](https://nix-community.github.io/stylix/options/modules/regreet.html).
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
    mkBefore
    mkDefault
    mkIf
    ;
  inherit (pkgs) writeShellScriptBin;

  cfg = config.biapy.services.displayManager.regreet;

  xkb-cage = writeShellScriptBin "xkb-cage" ''
    # Cage wrapper with Keyboard layout

    export XKB_DEFAULT_MODEL='${config.services.xserver.xkb.model}'
    export XKB_DEFAULT_LAYOUT='${config.services.xserver.xkb.layout}'
    export XKB_DEFAULT_VARIANT='${config.services.xserver.xkb.variant}'
    export XKB_DEFAULT_OPTIONS='${config.services.xserver.xkb.options}'

    exec ${getExe pkgs.cage} "''${@}"
  '';
in
{
  options = {
    biapy.services.displayManager.regreet.enable = mkEnableOption "regreet greeter";
  };

  config = mkIf cfg.enable {
    programs.regreet.enable = mkDefault true;

    services.greetd.settings.default_session.command =
      mkBefore "${pkgs.dbus}/bin/dbus-run-session ${getExe xkb-cage} ${lib.escapeShellArgs config.programs.regreet.cageArgs} -- ${getExe config.programs.regreet.package}";
  };
}
