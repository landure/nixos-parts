/**
  # biapy.console.network tests

  ## 🙇 Acknowledgements

  - [NixOS VM tests @ Official NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_VM_tests).
  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      nixosVersion = "26.05";
    in
    {
      checks."biapy.console.network" = inputs.nixpkgs.lib.nixos.runTest {
        name = "biapy.console.network";

        # logLevel = "debug";
        # enableDebugHook = true;

        hostPkgs = pkgs;
        node.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.self.overlays.default
          ];
        };

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
                  home.stateVersion = nixosVersion;
                };
              };
            }
            {
              home-manager.users.testbed = {
                imports = [
                  ../../../../home/_biapy/console/network.nix
                  ../../../../home/_biapy/programs/trippy.nix
                ];
                biapy.console.network.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")
          machine.succeed("su -- testbed -c 'which doge'")
          machine.succeed("su -- testbed -c 'which doggo'")
          machine.succeed("su -- testbed -c 'which fping'")
          machine.succeed("su -- testbed -c 'which gping'")
          machine.succeed("su -- testbed -c 'which nbping'")
          machine.succeed("su -- testbed -c 'which netop'")
          machine.succeed("su -- testbed -c 'which snitch'")
          machine.succeed("su -- testbed -c 'which trip'")
          machine.succeed("su -- testbed -c 'which wtfis'")
          machine.succeed("su -- testbed -c 'which netwatch'")
          machine.succeed("su -- testbed -c 'which cloudflare-speed-cli'")
          machine.succeed("su -- testbed -c 'which quien'")
          machine.succeed("su -- testbed -c 'which pktz'")
          machine.succeed("su -- testbed -c 'which wtfi'")
        '';
      };
    };
}
