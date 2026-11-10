/**
  # Office tools for the console.

  ## 🛠️ Tech Stack

  - [doxx @ GitHub](https://github.com/bgreenwell/doxx)
    is a fast, terminal-native document viewer for Word files.
  - [ripgrep-all (rga) @ GitHub](https://github.com/phiresky/ripgrep-all)
    is ripgrep, but also search in PDFs, E-Books, Office documents, `zip`, `tar.gz`, …
  - [tdf @ GitHub](https://github.com/itsjunetime/tdf)
    is a terminal-based PDF viewer.

  ### 📝 Note taking

  - [Joplin Terminal Application @ Joplin](https://joplinapp.org/help/apps/terminal/)
    is a note taking app.
  - [jrnl homepage](https://jrnl.sh/en/stable/)
    ([jrnl @ GitHub](https://github.com/jrnl-org/jrnl))
    is a journal application for the command line.
  - [rucola @ GitHub](https://github.com/Linus-Mussmaecher/rucola)
    is a terminal-based markdown note manager.

  ### 🗒️ Markdown viewers

  - [glow @ GitHub](https://github.com/charmbracelet/glow)
    renders markdown on the CLI, with pizzazz! 💅🏻
  - [Leaf homepage](https://leaf.rivolink.mg/)
    ([Leaf @ GitHub](https://github.com/rivolink/leaf))
    is a Terminal Markdown previewer with GUI-like experience.
  - [Markless @ GitHub](https://github.com/jvanderberg/markless)
    is a terminal markdown viewer with image support.

  ### 🗹 Task managers

  - [dstask @ GitHub](https://github.com/naggie/dstask)
    is a personal task tracker designed to help you focus.
    It is similar to Taskwarrior but uses git to synchronise instead of a special protocol.
  - [Taskwarrior homepage](https://taskwarrior.org/)
    ([Taskwarrior @ GitHub](https://github.com/GothenburgBitFactory/taskwarrior))
    is a command line task list management utility.
  - [taskwarrior-tui @ GitHub](https://github.com/kdheepak/taskwarrior-tui).
  - [tuxedo @ GitHub](https://github.com/webstonehq/tuxedo)
    is a fast, keyboard-driven terminal UI for todo.txt.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.jrnl @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/jrnl.html).
  - [programs.jrnl @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.jrnl.).
  - [programs.ripgrep-all @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/ripgrep-all.html).
  - [programs.ripgrep-all @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.ripgrep-all.).
  - [programs.taskwarrior @ Home Manager](https://nix-community.github.io/home-manager/options/home-manager/programs/taskwarrior.html).
  - [programs.taskwarrior @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.taskwarrior.).

  ## 🙇 Acknowledgements

  - [Episode 619: The Trouble with TUIs @ Linux Unplugged](https://linuxunplugged.com/619).
  - [Doxx - Pour lire vos fichiers Word depuis le terminal @ Korben 🇫🇷](https://korben.info/doxx-terminal-viewer-word-rust.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.biapy.console.office;
in
{
  options.biapy.console.office.enable = mkEnableOption "command-line office tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      doxx
      dstask
      glow
      rucola
      taskwarrior-tui
      tdf

      unstable.leaf-markdown-viewer
      unstable.markless
      unstable.tuxedo
    ];

    biapy.programs = {
      joplin-cli.enable = mkDefault true;
      zk.enable = mkDefault true;
    };

    programs = {
      jrnl.enable = mkDefault true;
      ripgrep-all.enable = mkDefault true;
      taskwarrior = {
        enable = mkDefault true;
        package = pkgs.taskwarrior3;
      };
    };

    # services.taskwarrior-sync.enable = mkDefault true;
  };
}
