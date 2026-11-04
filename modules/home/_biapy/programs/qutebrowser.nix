/**
  # qutebrowser

  qutebrowser is a keyboard-focused browser with a minimal GUI.
  It’s based on Python and Qt and free software, licensed under the GPL.

  ## 🛠️ Tech Stack

  - [qutebrowser homepage](https://qutebrowser.org/)
    ([qutebrowser @ GitHub](https://github.com/qutebrowser/qutebrowser)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.qutebrowser @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/qutebrowser.html).
  - [programs.qutebrowser @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.qutebrowser.).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.qutebrowser;
in
{
  options.biapy.programs.qutebrowser.enable = mkEnableOption "mise";

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = mkDefault true;

      searchEngines = {
        d = mkDefault "https://duckduckgo.com/?search={}";
        g = mkDefault "https://www.google.fr/search?hl=fr&q={}";
        w = mkDefault "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        wf = mkDefault "https://fr.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        aw = mkDefault "https://wiki.archlinux.org/?search={}";
        nw = mkDefault "https://wiki.nixos.org/index.php?search={}";
      };

      quickmarks = {
        gitmoji = mkDefault "https://gitmoji.dev/";
        php = mkDefault "https://www.php.net/";
        symfony = mkDefault "https://symfony.com/doc/current/index.html";
        nixpkgs = mkDefault "https://github.com/NixOS/nixpkgs";
        home-manager = mkDefault "https://github.com/nix-community/home-manager";
      };

      perDomainSettings = {
        "github.com".colors.webpage.darkmode.enabled = mkDefault false;
      };
      # settings = {
      #    tabs.tabs_are_windows =mkDefault true;
      # };
    };
  };
}
