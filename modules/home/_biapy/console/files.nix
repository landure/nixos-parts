/**
  # Files TUI tools

  ## 🛠️ Tech Stack

  - [bat @ GitHub](https://github.com/sharkdp/bat)
    is a `cat` clone with syntax highlighting and Git integration.
  - [f2 homepage](https://f2.freshman.tech/)
    ([f2 @ GitHub](https://github.com/ayoisaiah/f2))
    is a cross-platform command-line tool for batch renaming files
    and directories quickly and safely.
  - [ov homepage](https://noborus.github.io/ov/)
    ([ov @ GitHub](https://github.com/noborus/ov))
    is a feature-rich terminal-based pager.
  - [procs @ GitHub](https://github.com/dalance/procs)
    is a modern replacement for `ps` written in Rust.
  - [zoxide @ GitHub](https://github.com/ajeetdsouza/zoxide)
    is a smarter `cd` command, inspired by `z` and `autojump`.

  ### `ls`

  - [eza homepage](https://eza.rocks/)
    ([eza @ GitHub](https://github.com/eza-community/eza))
    is a modern alternative to `ls`.
  - [LSD (LSDeluxe) @ GitHub](https://github.com/lsd-rs/lsd)
    is a rewrite of GNU `ls` with lots of added features such as colors,
    icons, tree-view, more formatting options, …

  ### `find`

  - [fd @ GitHub](https://github.com/sharkdp/fd)
    is a simple, fast, and user-friendly alternative to 'find'.

  ### `grep`

  - [ast-grep homepage](https://ast-grep.github.io/)
    ([ast-grep @ GitHub](https://github.com/ast-grep/ast-grep))
    is a CLI tool for code structural search, lint and rewriting..
  - [ripgrep @ GitHub](https://github.com/BurntSushi/ripgrep)
    recursively searches directories for a regex pattern
    while respecting the `.gitignore`.

  ### `sed`

  - [amber @ GitHub](https://github.com/dalance/amber)
    is a code search and replace tool written by Rust. .
  - [sd - search & displace @ GitHub](https://github.com/chmln/sd)
    is an intuitive find & replace CLI (`sed` alternative).

  ### `cut`

  - [hck @ GitHub](https://github.com/sstadick/hck)
    is a shortening of hack, a rougher form of `cut`.
  - [tuc @ GitHub](https://github.com/riquito/tuc)
    cut text (or bytes) where a delimiter matches,
    then keep the desired parts.

  ### File managers

  - [joshuto @ GitHub](https://github.com/kamiyaa/joshuto)
    is a `ranger`-like terminal file manager written in Rust.
  - [superfile homepage](https://superfile.dev/)
    ([superfile @ GitHub](https://github.com/yorukot/superfile))
    is a fancy, modern terminal file manager.
  - [yazi homepage](https://yazi-rs.github.io/)
    ([yazi @ GitHub](https://github.com/sxyazi/yazi))
    is a blazing fast terminal file manager written in Rust,
    based on async I/O.

  ### `du`

  - [dust @ GitHub](https://github.com/bootandy/dust)
    is a more intuitive version of `du` in rust.

  ### `df`

  - [duf @ GitHub](https://github.com/muesli/duf/)
    (Disk Usage/Free utility) is a better `df` alternative.
  - [dysk homepage](https://dystroy.org/dysk/)
    ([dysk @ GitHub](https://github.com/Canop/dysk)
    is a linux utility to get information on filesystems,
    like `df` but better.

  ### other alternatives

  - [ag, The Silver Searcher @ GitHub](https://github.com/ggreer/the_silver_searcher)
    is a code-searching tool similar to `ack`, but faster.
  - [bfs @ GitHub](https://github.com/tavianator/bfs)
    is a breadth-first version of the UNIX `find` command
  - [moor @ GitHub](https://github.com/walles/moor)
     is a pager designed to just do the right thing
     without any configuration..

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.amber @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.amber.enable).
  - [programs.amber @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.amber.).
  - [programs.bat @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable).
  - [programs.bat @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.bat.).
  - [programs.fd @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable).
  - [programs.fd @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.fd.).
  - [programs.joshuto @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.joshuto.enable).
  - [programs.joshuto @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.joshuto.).
  - [programs.lsd @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lsd.enable).
  - [programs.lsd @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.lsd.).
  - [programs.ripgrep @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable).
  - [programs.ripgrep @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.ripgrep.).
  - [programs.superfile @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.superfile.enable).
  - [programs.superfile @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.superfile.).
  - [programs.yazi @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enable).
  - [programs.yazi @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.yazi.).
  - [programs.zoxide @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enable).
  - [programs.zoxide @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.zoxide.).

  ### 🎨 Stylix

  - [yazi @ Stylix](https://nix-community.github.io/stylix/options/modules/yazi.html).

  ## 🙇 Acknowledgements

  - [Awesome Alternatives in Rust @ GitHub](https://github.com/TaKO8Ki/awesome-alternatives-in-rust).
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

  cfg = config.biapy.console.files;
in
{
  options = {
    biapy.console.files = {
      enable = mkEnableOption "command-line files TUI tools";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      ast-grep
      dust # du alternative
      duf # df alternalive
      dysk # df alternative
      f2 # Batch file renamer
      hck # cut alternative
      moor # pager
      ov # Feature-rich terminal-based text viewer
      sd
      tuc # cut drop-in replacement writen in Rust

      biapy-parts.rgsd
    ];

    biapy.programs = {
      bat.enable = mkDefault true;
      eza.enable = mkDefault true;
    };

    # Let Home Manager install and manage itself.
    programs = {
      # search & replace
      amber.enable = mkDefault true;

      # `rg`: line-oriented search tool that recursively searches the current directory for a regex pattern
      ripgrep.enable = mkDefault true;

      fd.enable = mkDefault true;

      joshuto.enable = mkDefault true;
      superfile.enable = mkDefault true;
      yazi = {
        enable = mkDefault true;
        shellWrapperName = mkDefault "y";
      };

      # `z` is a smarter cd command, inspired by z and autojump.
      zoxide.enable = mkDefault true;
    };
  };
}
