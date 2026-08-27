/**
  # Git

  Git is a free and open source distributed version control system designed
  to handle everything from small to very large projects with speed
  and efficiency.

  ## 🛠️ Tech Stack

  - [Git homepage](https://git-scm.com/).
  - [Git worktree switcher ⚡ @ GitHub](https://github.com/yankeexe/git-worktree-switcher).
  - [git-credential-keepassxc @ GitHub](https://github.com/frederick888/git-credential-keepassxc).
  - [git-credential-oauth @ GitHub](https://github.com/hickford/git-credential-oauth).

  - [LazyGit @ GitHub](https://github.com/jesseduffield/lazygit).
  - [GitUI @ GitHub](https://github.com/gitui-org/gitui).
  - [LazyWorktree homepage](https://chmouel.github.io/lazyworktree/)
    ([LazyWorktree @ GitHub](https://github.com/chmouel/lazyworktree)).
  - [onefetch homepage](https://onefetch.dev/)
    ([onefetch @ GitHub](https://github.com/o2sh/onefetch))
    displays project information and code statistics for a local Git repository.

  - [GitHub CLI homepage](https://cli.github.com/)
    ([GitHub CLI @ GitHub](https://github.com/cli/cli)).
  - [GLab @ GitLab](https://gitlab.com/gitlab-org/cli).

  - [difftastic homepage](https://difftastic.wilfred.me.uk/)
    ([difftastic @ GitHub](https://github.com/Wilfred/difftastic)).
  - [diff-so-fancy @ GitHub](https://github.com/so-fancy/diff-so-fancy).
  - [diff-hightlight @ Git's GitHub](https://github.com/git/git/tree/master/contrib/diff-highlight).
  - [delta homepage](https://dandavison.github.io/delta/)
    ([delta @ GitHub](https://github.com/dandavison/delta)).
  - [riff @ GitHub](https://github.com/walles/riff).
  - [Patdiff homepage](https://opensource.janestreet.com/patdiff/)
    ([Patdiff @ GitHub](https://github.com/janestreet/patdiff)).
  - [Mergiraf homepage](https://mergiraf.org/)
    ([Mergiraf @ Codeberg](https://codeberg.org/mergiraf/mergiraf)).

  - [Jujutsu homepage](https://www.jj-vcs.dev/latest/)
    ([Jujutsu @ GitHub](https://www.jj-vcs.dev/latest/)).
  - [Jujutsu UI (jjui) homepage](https://idursun.github.io/jjui/)
    ([Jujutsu UI @ GitHub](https://github.com/idursun/jjui)).

  ## 📝 Documentation

  - [programs.git @ NixOS reference](https://search.nixos.org/options?query=programs.git).

  ### 🏠 Home Manager Configuration Options

  - [programs.delta](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.enable).
  - [programs.gh](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.enable).
  - [programs.git-credential-keepassxc](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git-credential-keepassxc.enable).
  - [programs.git-credential-oauth](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git-credential-oauth.enable).
  - [programs.git-worktree-switcher @ GitHub](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git-worktree-switcher.enable).
  - [programs.git](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable).
  - [programs.gitui](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gitui.enable).
  - [programs.jjui](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jjui.enable).
  - [programs.jujutsu](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jujutsu.enable).
  - [programs.lazygit](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lazygit.enable).
  - [programs.lazyworktree](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lazyworktree.enable).
  - [programs.mergiraf](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mergiraf.enable).

  ### 🎨 Stylix

  - [GitUI @ Stylix](https://nix-community.github.io/stylix/options/modules/gitui.html).
  - [LazyGit @ Stylix](https://nix-community.github.io/stylix/options/modules/lazygit.html).

  ## 🙇 Acknowledgements

  - [Git @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Git).
  - [Git @ NixOS Wiki](https://nixos.wiki/wiki/Git).
  - [A Collection of Useful .gitattributes Templates @ GitHub](https://github.com/gitattributes/gitattributes).
  - [Archiving git branches as tags @ et cetera](https://etc.octavore.com/2025/12/archiving-git-branches-as-tags/).
  - [How to Customize Git Help for Your Aliases in NixOS @ PUPUWEB](https://pupuweb.com/how-customize-git-help-aliases-nixos/).
  - [What is the cleanest way to add Git Alias project to Home manager config? @ r/NixOS](https://www.reddit.com/r/NixOS/comments/rtj5h2/what_is_the_cleanest_way_to_add_git_alias_project/).
  - [Git Rebase @ Alchemists](https://alchemists.io/articles/git_rebase).
  - [Git: Improve diff generation with diff.algorithm=histogram @ Adam Johnson](https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/).
  - [How Core Git Developers Configure Git @ GitButler](https://blog.gitbutler.com/how-git-core-devs-configure-git/).
  - [Git Rebase AutoSquash @ Alchemists](https://alchemists.io/articles/git_rebase_autosquash).
  - [A Trick To Use mkMerge at The Top Level of a NixOS module @ Samara's GitHub Gist](https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43).
  - [Git Worktree Comme Un Chef @ Metal3d 🇫🇷](https://www.metal3d.org/blog/2026/git-worktree-comme-un-chef/).
  - [The Git Commands I Run Before Reading Any Code @ Ally Piechowski](https://piechowski.io/post/git-commands-before-reading-code/).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.types) bool;

  cfg = config.biapy.dev.git;

in
{
  options = {
    biapy.dev.git = {
      enable = mkEnableOption "Git";

      jujutsu = mkOption {
        type = bool;
        default = true;
        description = "Wether to install jujutsu";
      };
    };
  };

  config = mkIf cfg.enable {
    biapy.programs = {
      gh.enable = mkDefault true;
      git.enable = mkDefault true;
      gitalias.enable = mkDefault true;
      git-utils.enable = mkDefault true;
      jujutsu.enable = mkDefault cfg.jujutsu;
      lazygit.enable = mkDefault true;
    };

    home.packages = with pkgs; [
      glab
      onefetch
    ];

    programs = {

      # gitui.enable = mkDefault true;

      #lazyworktree = {
      #  enable = mkDefault true;
      # settings = {
      #   auto_fetch_prs = false;
      #   auto_refresh = true;
      #   fuzzy_finder_input = false;
      #   icon_set = "nerd-font-v3";
      #   refresh_interval = 10;
      #   search_auto_select = false;
      #   sort_mode = "switched";
      #   worktree_dir = "~/.local/share/worktrees";
      # };
      #};

      delta = {
        enable = mkDefault true;
        enableGitIntegration = false;
        enableJujutsuIntegration = mkDefault config.programs.jujutsu.enable;
      };

      # diff-so-fancy.enable = true;
      # diff-highlight.enable = true;
      # patdiff.enable = true;
      # riff.enable = true;

      difftastic = {
        enable = mkDefault true;
        git.enable = mkDefault true;
        # jujutsu = mkDefault config.programs.jujutsu.enable;
      };

      mergiraf = {
        enable = mkDefault true;
        enableGitIntegration = mkDefault true;
        enableJujutsuIntegration = mkDefault true;
      };

      git-worktree-switcher.enable = mkDefault true;
      git-credential-oauth.enable = mkDefault true;
      git-credential-keepassxc.enable = mkDefault config.programs.keepassxc.enable;

      jujutsu.enable = mkDefault cfg.jujutsu;
      jjui.enable = mkDefault config.programs.jujutsu.enable;
    };
  };
}
