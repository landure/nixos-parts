/**
  # biapy.programs.nom tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.nom" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.nom";

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
                  ../../../../home/_biapy/programs/nom.nix
                ];
                biapy.programs.nom.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")
          # `nom` is renamed to `nomrss` to avoid clashing with nix-output-monitor.
          machine.succeed("su -- testbed -c 'which nomrss'")
          machine.fail("su -- testbed -c 'which nom'")
        '';
      };
    };
}
