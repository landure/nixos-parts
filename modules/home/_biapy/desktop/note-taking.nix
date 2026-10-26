/**
  # Note taking tools for desktop environments.

  ## 🛠️ Tech Stack

  - [Joplin Desktop](https://joplinapp.org/)
    ([Joplin @ GitHub](https://github.com/laurent22/joplin/))
    is an open source note-taking app.
  - [Helix Notes @ GitLab](https://gitlab.com/ArkHost/HelixNotes)
    is a local, open-source Markdown note-taking app.
  - [Zettlr homepage](https://www.zettlr.com/)
    [Zettlr @ GitHub](https://github.com/Zettlr/Zettlr)
    is a One-Stop Publication Workbench.
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

  cfg = config.biapy.desktop.note-taking;
in
{
  options.biapy.desktop.note-taking.enable = mkEnableOption "note taking tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # helix-notes.default
      zettlr
    ];

    biapy.programs = {
      joplin-desktop = {
        enable = mkDefault true; # Note taking GUI
        sync = {
          target = mkDefault "joplin-server";
          settings = mkDefault {
            path = "https://joplin.biapy.fr/";
            username = config.biapy.user.identity.email;
          };
        };
      };
    };
  };
}
