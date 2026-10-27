/**
  # Web-related tools for the console.

  ## 🛠️ Tech Stack

  - [aerc @ sourcehut](https://sr.ht/~rjarry/aerc/)
    is an email client for your terminal.
  - [Chawan homepage](https://chawan.net/).
    ([Chawan @ sourcehut](https://sr.ht/~bptato/chawan/))
    is a TUI web browser.
  - [ddgr @ GitHub(https://github.com/jarun/ddgr)
    is 🦆 DuckDuckGo from the terminal.
  - [gomuks @ GitHub](https://github.com/gomuks/gomuks)
    is a Matrix client written in Go.
  - [irssi homepage](https://irssi.org/)
    is a modular text mode chat client. It comes with IRC support built in.
  - [meli homepage](https://meli-email.org/)
    ([meli @ GitHub](https://github.com/meli/meli))
    is a terminal mail client.
  - [monolith @ GitHub](https://github.com/Y2Z/monolith)
    is a GUI/CLI tool and library for saving complete web pages
    as a single HTML file.
  - [nom @ GitHub](https://github.com/guyfedwards/nom)
    is a RSS reader for the terminal.
  - [readability-cli @ GitLab](https://gitlab.com/gardenappl/readability-cli)
    takes any HTML page and strips out unnecessary bloat
    by using Mozilla's Readability library.
  - [russ @ GitHub](https://github.com/ckampfe/russ)
    is a TUI RSS reader with vim-like controls and a local-first,
    offline-first focus.
  - [tuifeed @ GitHub](https://github.com/veeso/tuifeed)
    is a terminal feed reader with a fancy ui.
  - [wiki-tui homepage](https://wiki-tui.net/latest/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.aerc @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/aerc.html).
  - [programs.chawan @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/chawan.html).
  - [programs.irssi @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/irssi.html).
  - [programs.meli @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/meli.html).

  ## 🙇 Acknowledgements

  - [Episode 619: The Trouble with TUIs @ Linux Unplugged](https://linuxunplugged.com/619)
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

  cfg = config.biapy.console.web;
in
{
  options.biapy.console.web.enable = mkEnableOption "Wayland command-line tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      ddgr # DuckDuckGo search CLI client
      # gomuks # Matrix client (requires insecure olm library)
      monolith # Archiving a web page in a single HTML file
      # readability-cli
      russ # RSS feed reader
      tuifeed # RSS feed reader
      wget
      wiki-tui # TUI for browsing Wikipedia
    ];

    programs = {
      aerc.enable = mkDefault true;
      chawan.enable = mkDefault true;
      irssi.enable = mkDefault true;
      meli.enable = mkDefault true;
      nom.enable = mkDefault true;
    };
  };
}
