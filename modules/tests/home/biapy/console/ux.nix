/**
  # biapy.console.ux tests

  ## 🙇 Acknowledgements

  - [NixOS VM tests @ Official NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_VM_tests).
  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
*/
{
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.console.ux" = pkgs.testers.runNixOSTest {
        name = "biapy.console.ux";

        nodes.machine = _: {
          imports = [
            inputs.home-manager.nixosModules.home-manager

            {
              users.users.testbed = {
                isNormalUser = true;
              };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.testbed = {
                  home.stateVersion = "26.05";
                };
              };
            }
            {
              home-manager.users.testbed = {
                imports = [
                  inputs.nix-index-database.homeModules.default
                  ../../../../home/_biapy/console/ux.nix
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/programs/bash.nix
                  ../../../../home/_biapy/programs/bat.nix
                  ../../../../home/_biapy/programs/cargo.nix
                  ../../../../home/_biapy/programs/eza.nix
                  ../../../../home/_biapy/programs/fastfetch.nix
                  ../../../../home/_biapy/programs/flyline.nix
                  ../../../../home/_biapy/programs/fzf.nix
                  ../../../../home/_biapy/programs/go.nix
                  ../../../../home/_biapy/programs/gum.nix
                  ../../../../home/_biapy/programs/mcfly.nix
                  ../../../../home/_biapy/programs/mise.nix
                  ../../../../home/_biapy/programs/pay-respects.nix
                  ../../../../home/_biapy/programs/ripgrep.nix
                  ../../../../home/_biapy/programs/skim.nix
                  ../../../../home/_biapy/programs/starship.nix
                  ../../../../home/_biapy/programs/zellij.nix
                  ../../../../home/_biapy/programs/zsh.nix
                  ../../../../home/_biapy/shellAliases/systemd-inhibit.nix
                ];
                biapy.console.ux.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which gawk'")
          machine.succeed("su -- testbed -c 'which sd'")
        '';
      };
    };
}
