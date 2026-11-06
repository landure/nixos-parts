/**
  # Web tools

  ## 🛠️ Tech Stack

  - [Halloy homepage](https://halloy.chat/)
    ([Halloy @ GitHub](https://github.com/squidowl/halloy))
    is an IRC application written in Rust.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.halloy @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/halloy.html).
  - [programs.halloy @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.halloy.).

  ### 🎨 Stylix

  - [Halloy @ Stylix](https://nix-community.github.io/stylix/options/modules/halloy.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.desktop.web;
in
{
  options.biapy.desktop.web.enable = mkEnableOption "Web tools";

  config = mkIf cfg.enable {
    biapy.programs.firefox.enable = true;

    programs = {
      halloy.enable = mkDefault true;
    };

    xdg = {
      mimeApps = {
        # Example default apps configuration.
        defaultApplications = {
          "text/html" = [ "firefox.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "application/xhtml+xml" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
        };
        associations.added = {
          "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop;firefox.desktop" ];
          "text/html" = [ "org.qutebrowser.qutebrowser.desktop;firefox.desktop" ];
          "application/xhtml+xml" = [ "org.qutebrowser.qutebrowser.desktop;firefox.desktop" ];
          "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop;firefox.desktop" ];
        };
      };

      desktopEntries = {
        # Custom firefox desktop entry, to override default app for links
        # firefox = {
        #   name = "Firefox";
        #   genericName = "Web Browser";
        #   exec = "firefox %U";
        #   terminal = false;
        #   categories = [
        #     "Application"
        #     "Network"
        #     "WebBrowser"
        #   ];
        #   mimeType = [
        #     "text/html"
        #     "text/xml"
        #   ];
        # };
      };
    };
  };
}
