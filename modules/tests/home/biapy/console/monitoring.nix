/**
  # biapy.console.monitoring tests

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
      checks."biapy.console.monitoring" = pkgs.testers.runNixOSTest {
        name = "biapy.console.monitoring";

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
                  ../../../../home/_biapy/console/monitoring.nix
                  ../../../../home/_biapy/programs/fastfetch.nix
                ];
                biapy.console.monitoring.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which dool'")
          machine.succeed("su -- testbed -c 'which inxi'")
          machine.succeed("su -- testbed -c 'which iotop'")
          machine.succeed("su -- testbed -c 'which procs'")
          machine.succeed("su -- testbed -c 'which ramfetch'")
          machine.succeed("su -- testbed -c 'which witr'")
        '';
      };
    };
}
