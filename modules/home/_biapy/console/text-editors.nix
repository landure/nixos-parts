/**
  # Command-line text editors

  ## 🙇 Acknowledgements

  - [Tilde homepage](https://os.ghalkes.nl/tilde/)
    ([Tilde @ GitHub](https://github.com/gphalkes/tilde)).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.lists) elem optional;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr listOf enum;

  cfg = config.biapy.console.text-editors;

  editors = [
    "emacs"
    "fresh-editor"
    "helix"
    "kakoune"
    "micro"
    "msedit"
    "ne"
    "neovim"
    "vim"
  ];
in
{
  options = {
    biapy.console.text-editors = {
      enable = mkEnableOption "command-line text editors";

      editors = mkOption {
        type = listOf (enum editors);
        default = [
          "fresh-editor"
          "helix"
          "micro"
          "msedit"
          "ne"
          "neovim"
        ];
        description = ''
          What editors to enable.
        '';
        apply = value: value ++ (optional (cfg.default != null) cfg.default);
      };

      default = mkOption {
        type = nullOr (enum [
          "emacs"
          "fresh-editor"
          "helix"
          "kakoune"
          "msedit"
          "micro"
          "ne"
          "neovim"
          "emacs"
        ]);
        default = "helix";
        description = ''
          What editor to use as default EDITOR.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    biapy.programs = {
      emacs.enable = mkDefault (elem "emacs" cfg.editors);
      fresh-editor.enable = mkDefault (elem "fresh-editor" cfg.editors);
      helix.enable = mkDefault (elem "helix" cfg.editors);
      kakoune.enable = mkDefault (elem "kakoune" cfg.editors);
      micro.enable = mkDefault (elem "micro" cfg.editors);
      msedit.enable = mkDefault (elem "msedit" cfg.editors);
      ne.enable = mkDefault (elem "ne" cfg.editors);
      neovim.enable = mkDefault (elem "neovim" cfg.editors);
      vim.enable = mkDefault (elem "vim" cfg.editors);
    };
  };
}
