/**
  # Office tools for the console.

  ## 🛠️ Tech Stack

  - [doxx @ GitHub](https://github.com/bgreenwell/doxx)
    is a fast, terminal-native document viewer for Word files.
  - [dstask @ GitHub](https://github.com/naggie/dstask)
    is a personal task tracker designed to help you focus.
    It is similar to Taskwarrior but uses git to synchronise instead of a special protocol.
  - [glow @ GitHub](https://github.com/charmbracelet/glow)
    renders markdown on the CLI, with pizzazz! 💅🏻
  - [Joplin Terminal Application @ Joplin](https://joplinapp.org/help/apps/terminal/)
    is a note taking app.
  - [jrnl homepage](https://jrnl.sh/en/stable/)
    ([jrnl @ GitHub](https://github.com/jrnl-org/jrnl))
    is a journal application for the command line.
  - [ripgrep-all (rga) @ GitHub](https://github.com/phiresky/ripgrep-all)
    is ripgrep, but also search in PDFs, E-Books, Office documents, `zip`, `tar.gz`, …
  - [rucola @ GitHub](https://github.com/Linus-Mussmaecher/rucola)
    is a terminal-based markdown note manager..
    - [Taskwarrior homepage](https://taskwarrior.org/)
      ([Taskwarrior @ GitHub](https://github.com/GothenburgBitFactory/taskwarrior))
      is a command line task list management utility.
  - [tdf @ GitHub](https://github.com/itsjunetime/tdf)
    is a terminal-based PDF viewer.

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.jrnl @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jrnl.enable).
  - [programs.jrnl @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.jrnl.).
  - [programs.ripgrep-all @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep-all.enable).
  - [programs.ripgrep-all @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.ripgrep-all.).
  - [programs.taskwarrior @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.taskwarrior.enable).
  - [programs.taskwarrior @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.taskwarrior.).

  ## 🙇 Acknowledgements

  - [Episode 619: The Trouble with TUIs @ Linux Unplugged](https://linuxunplugged.com/619).
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
  options = {
    biapy.console.office = {
      enable = mkEnableOption "command-line office tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
        doxx
        dstask
        glow
        rucola
        tdf
      ];

    biapy.programs.joplin-cli.enable = mkDefault true;

    programs = {
      jrnl.enable = mkDefault true;
      ripgrep-all.enable = mkDefault true;
      taskwarrior.enable = mkDefault true;
    };

    # services.taskwarrior-sync.enable = mkDefault true;
  };
}
