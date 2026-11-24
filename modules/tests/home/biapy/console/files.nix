/**
  # biapy.console.files tests

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
      checks."biapy.console.files" = pkgs.testers.runNixOSTest {
        name = "biapy.console.files";

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
                  ../../../../home/_biapy/console/files.nix
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/programs/ast-grep.nix
                  ../../../../home/_biapy/programs/bat.nix
                  ../../../../home/_biapy/programs/duf.nix
                  ../../../../home/_biapy/programs/eza.nix
                  ../../../../home/_biapy/programs/gum.nix
                  ../../../../home/_biapy/programs/ripgrep.nix
                ];
                biapy.console.files.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which dust'")
          machine.succeed("su -- testbed -c 'which dysk'")
          machine.succeed("su -- testbed -c 'which f2'")
          machine.succeed("su -- testbed -c 'which hck'")
          machine.succeed("su -- testbed -c 'which moor'")
          machine.succeed("su -- testbed -c 'which ov'")
          machine.succeed("su -- testbed -c 'which sd'")
          machine.succeed("su -- testbed -c 'which tuc'")
          machine.succeed("su -- testbed -c 'which unp'")
          machine.succeed("su -- testbed -c 'which rsync'")
        '';
      };
    };
}
