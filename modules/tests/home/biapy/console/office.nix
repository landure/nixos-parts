/**
  # biapy.console.office tests

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
      checks."biapy.console.office" = pkgs.testers.runNixOSTest {
        name = "biapy.console.office";

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
                  inputs.sops-nix.homeManagerModules.sops
                  ../../../../home/_biapy/console/office.nix
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/programs/bat.nix
                  ../../../../home/_biapy/programs/joplin-cli.nix
                  ../../../../home/_biapy/programs/joplin-desktop.nix
                  ../../../../home/_biapy/programs/mq.nix
                  ../../../../home/_biapy/programs/taskwarrior.nix
                  ../../../../home/_biapy/programs/zk.nix
                  ../../../../home/_biapy/user/identity.nix
                ];
                biapy.console.office.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which doxx'")
          machine.succeed("su -- testbed -c 'which dstask'")
          machine.succeed("su -- testbed -c 'which glow'")
          machine.succeed("su -- testbed -c 'which rucola'")
          machine.succeed("su -- testbed -c 'which tdf'")
        '';
      };
    };
}
