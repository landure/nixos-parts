/**
  # biapy.dev.tui-api-clients tests

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
      checks."biapy.dev.tui-api-clients" = pkgs.testers.runNixOSTest {
        name = "biapy.dev.tui-api-clients";

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
                  ../../../../home/_biapy/dev/tui-api-clients.nix
                ];
                biapy.dev.tui-api-clients.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which curl'")
          machine.succeed("su -- testbed -c 'which curlie'")
          machine.succeed("su -- testbed -c 'which httpie'")
          machine.succeed("su -- testbed -c 'which posting'")
          machine.succeed("su -- testbed -c 'which xh'")
        '';
      };
    };
}
