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
          machine.succeed("test -x /home/testbed/.nix-profile/bin/doge")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/doggo")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/gping")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/nbping")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/netop")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/snitch")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/trip")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/wtfis")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/netwatch")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/cloudflare-speed-cli")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/quien")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/pktz")
          machine.succeed("test -x /home/testbed/.nix-profile/bin/wtfi2")
        '';
      };
    };
}
