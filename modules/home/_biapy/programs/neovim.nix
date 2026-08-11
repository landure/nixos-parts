/**
  # NeoVim

  ## 🛠️ Tech Stack

  - [Neovim](https://neovim.io/)
    ([Neovim @ GitHub](https://github.com/neovim/neovim)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.neovim @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.enable).

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

  cfg = config.biapy.programs.neovim;

in
{
  options = {
    biapy.programs.neovim.enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = mkDefault true;
      # Whether to configure nvim as the default editor using the EDITOR environment variable.
      defaultEditor = mkDefault (config.biapy.console.text-editors.default == "neovim");
      # The extra Lua packages required for your plugins to work.
      # This option accepts a function that takes a Lua package set as an argument,
      # and selects the required Lua packages from this package set.
      extraLuaPackages =
        luaPkgs: with luaPkgs; [
          # luautf8
          luarocks
        ];

      # The extra Python 3 packages required for your plugins to work.
      # This option accepts a function that takes a Python 3 package set as an argument,
      # and selects the required Python 3 packages from this package set.
      extraPython3Packages =
        pyPkgs: with pyPkgs; [
          # pyPkgs.python-language-server
          pynvim
        ];
      # Symlink vi to nvim binary.
      viAlias = mkDefault (!config.programs.vim.enable);
      # Symlink vim to nvim binary.
      vimAlias = mkDefault (!config.programs.vim.enable);
      # Alias vimdiff to nvim -d.
      vimdiffAlias = mkDefault true;
      # Enable node provider. Set to true to use Node plugins.
      withNodeJs = mkDefault true;
      # Enable Python 3 provider. Set to true to use Python 3 plugins.
      withPython3 = mkDefault true;
      # Enable ruby provider.
      withRuby = mkDefault true;
    };

  };
}
