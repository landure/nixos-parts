/**
  # fzf

  fzf fuzzy finder, with custom setup & aliases

  ## 🛠️ Tech Stack

  - [fzf homepage](https://junegunn.github.io/fzf/)
    ([fzf @ GitHub](https://github.com/junegunn/fzf)).
  - [fd @ GitHub](https://github.com/sharkdp/fd).
  - [bat @ GitHub](https://github.com/sharkdp/bat).
  - [ripgrep (rg) @ GitHub](https://github.com/BurntSushi/ripgrep).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.fzf](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable).
  - [programs.fd](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable).
  - [programs.bat](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable).
  - [programs.ripgrep](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable).

  ## 🙇 Acknowledgements

  - [FZF vs Skim (October 2025): which fuzzy finder should power your terminal? @ GitgasBlade](https://gigasblade.blogspot.com/2025/10/fzf-vs-skim-october-2025-which-fuzzy.html).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.fzf;

in
{
  options = {
    biapy.programs.fzf = {
      enable = mkEnableOption "fzf";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      fd.enable = mkDefault true;
      bat.enable = mkDefault true;
      ripgrep.enable = mkDefault true;

      fzf = {
        enable = mkDefault true;
        defaultCommand = "${getExe config.programs.fd.package} --type 'f' --hidden --follow --exclude '.git'";
        defaultOptions = [
          "--height=40%"
          "--layout=reverse"
          "--border"
          "--info=inline"
          "--preview='${getExe config.programs.bat.package} --style=numbers --color=always --line-range :500 {}'"
          "--preview-window=right:60%:wrap"
        ];
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "fzrg" ''
        # Live grep
        ${getExe config.programs.ripgrep.package} --line-number --no-heading --color=always "" |
        ${getExe config.programs.fzf.package} --ansi --delimiter ':' \
          --bind='change:reload:rg --line-number --no-heading --color=always {q} || true' \
          --preview='${getExe config.programs.bat.package} --style=numbers --color=always --highlight-line {2} {1}' \
          --preview-window='right:70%:wrap'
      '')
    ];
  };
}
