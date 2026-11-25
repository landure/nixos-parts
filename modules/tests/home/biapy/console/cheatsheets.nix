/**
  # biapy.console.cheatsheets tests

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
      checks."biapy.console.cheatsheets" = pkgs.testers.runNixOSTest {
        name = "biapy.console.cheatsheets";

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
                  ../../../../home/_biapy/console/cheatsheets.nix
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/programs/tealdeer.nix
                ];
                biapy.console.cheatsheets.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which arsenal'")
          machine.succeed("su -- testbed -c 'which cht.sh'")
          machine.succeed("su -- testbed -c 'which tldr'")
        '';
      };
    };
}
