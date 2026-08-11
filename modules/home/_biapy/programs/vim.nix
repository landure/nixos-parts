/**
  # Vim editor

  ## 🛠️ Tech Stack

  - [vim homepage](https://www.vim.org/).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.vim @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vim.enable).

  ### 🎨 Stylix

  - [Neovim, Neovide, NixVim, nvf, and Vim](https://nix-community.github.io/stylix/options/modules/neovim.html).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.vim;
in
{
  options = {
    biapy.programs.vim.enable = mkEnableOption "vim";
  };

  config = mkIf cfg.enable {
    programs.vim = {
      enable = mkDefault true;
      defaultEditor = mkDefault (config.biapy.console.text-editors.default == "vim");
      extraConfig = mkDefault ''
        " Mouse support
        set mouse=a
        set ttymouse=sgr
        set balloonevalterm
        " Styled and colored underline support
        let &t_AU = "\e[58:5:%dm"
        let &t_8u = "\e[58:2:%lu:%lu:%lum"
        let &t_Us = "\e[4:2m"
        let &t_Cs = "\e[4:3m"
        let &t_ds = "\e[4:4m"
        let &t_Ds = "\e[4:5m"
        let &t_Ce = "\e[4:0m"
        " Strikethrough
        let &t_Ts = "\e[9m"
        let &t_Te = "\e[29m"
        " Truecolor support
        let &t_8f = "\e[38:2:%lu:%lu:%lum"
        let &t_8b = "\e[48:2:%lu:%lu:%lum"
        let &t_RF = "\e]10;?\e\\"
        let &t_RB = "\e]11;?\e\\"
        " Bracketed paste
        let &t_BE = "\e[?2004h"
        let &t_BD = "\e[?2004l"
        let &t_PS = "\e[200~"
        let &t_PE = "\e[201~"
        " Cursor control
        let &t_RC = "\e[?12"
        let &t_SH = "\e[%d q"
        let &t_RS = "\eP q\e\\"
        let &t_SI = "\e[5 q"
        let &t_SR = "\e[3 q"
        let &t_EI = "\e[1 q"
        let &t_VS = "\e[?12l"
        " Focus tracking
        let &t_fe = "\e[?1004h"
        let &t_fd = "\e[?1004l"
        execute "set <FocusGained>=\<Esc>[I"
        execute "set <FocusLost>=\<Esc>[O"
        " Window title
        let &t_ST = "\e[22;2t"
        let &t_RT = "\e[23;2t"

        " vim hardcodes background color erase even if the terminfo file does
        " not contain bce. This causes incorrect background rendering when
        " using a color theme with a background color in terminals such as
        " kitty that do not support background color erase.
        let &t_ut=""

        " List mode: special characters are visible, line break is visible as $.
        set list
        " Enable line numbering.
        set number

        " Expand tabulations to spaces.
        "set expandtab
        " Tabulation is displayed by a 2 characters blank space.
        set tabstop=2
        " Tabulation is replaced by 2 spaces characters.
        set softtabstop=2
        " Indentation width is 2 spaces.
        set shiftwidth=2

        " Do not create backup of edited files (prevent clutter).
        set nobackup

        " Use utf-8 encoding for edition.
        set encoding=utf-8
        " Store file with utf-8 encoding.
        set fileencoding=utf-8

        " Disable auto-indent, since it bugs on copy-pasting.
        set noautoindent
        setlocal nocindent
        setlocal nosmartindent
        setlocal indentexpr=

        " Enable syntax colorization.
        syn on
      '';
    };
  };
}
