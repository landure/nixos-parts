/**
  # Files TUI tools

  ## 🛠️ Tech Stack

  - [amber @ GitHub](https://github.com/dalance/amber).
  - [bat @ GitHub](https://github.com/sharkdp/bat).
  - [f2 homepage](https://f2.freshman.tech/)
    ([f2 @ GitHub](https://github.com/ayoisaiah/f2)).
  - [ov homepage](https://noborus.github.io/ov/)
    ([ov @ GitHub](https://github.com/noborus/ov)).
  - [procs @ GitHub](https://github.com/dalance/procs).
  - [zoxide @ GitHub](https://github.com/ajeetdsouza/zoxide).

  ### `ls`

  - [eza homepage](https://eza.rocks/)
    ([eza @ GitHub](https://github.com/eza-community/eza)).
  - [LSD (LSDeluxe) @ GitHub](https://github.com/lsd-rs/lsd).

  ### `find`

  - [fd @ GitHub](https://github.com/sharkdp/fd).

  ### `grep`

  - [ripgrep @ GitHub](https://github.com/BurntSushi/ripgrep).

  ### `cut`

  - [hck @ GitHub](https://github.com/sstadick/hck).
  - [tuc @ GitHub](https://github.com/riquito/tuc).

  ### File managers

  - [joshuto @ GitHub](https://github.com/kamiyaa/joshuto).
  - [yazi homepage](https://yazi-rs.github.io/)
    ([yazi @ GitHub](https://github.com/sxyazi/yazi)).

  ### `du`

  - [dust @ GitHub](https://github.com/bootandy/dust).

  ### `df`

  - [duf @ GitHub](https://github.com/muesli/duf/).
  - [dysk homepage](https://dystroy.org/dysk/)
    ([dysk @ GitHub](https://github.com/Canop/dysk).

  ### other alternatives

  - [ag, The Silver Searcher @ GitHub](https://github.com/ggreer/the_silver_searcher).
  - [moor @ GitHub](https://github.com/walles/moor).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.amber @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.amber.enable).
  - [programs.bat @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable).
  - [programs.fd @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable).
  - [programs.joshuto @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.joshuto.enable).
  - [programs.lsd @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lsd.enable).
  - [programs.ripgrep @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable).
  - [programs.yazi @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enable).
  - [programs.zoxide @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enable).

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
      dust # du alternative
      duf # df alternalive
      dysk # df alternative
      f2 # Batch file renamer
      hck # cut alternative
      moor # pager
      ov # Feature-rich terminal-based text viewer
      tuc # cut drop-in replacement writen in Rust
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

      yazi = {
        enable = mkDefault true;
        shellWrapperName = mkDefault "y";
      };

      # `z` is a smarter cd command, inspired by z and autojump.
      zoxide.enable = mkDefault true;
    };
  };
}
