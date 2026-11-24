/**
  # biapy.dev.json tests

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
      checks."biapy.dev.json" = pkgs.testers.runNixOSTest {
        name = "biapy.dev.json";

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
                  ../../../../home/_biapy/dev/json.nix
                ];
                biapy.dev.json.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which fx'")
          machine.succeed("su -- testbed -c 'which jaq'")
          machine.succeed("su -- testbed -c 'which jsongrep'")
          machine.succeed("su -- testbed -c 'which jid'")
          machine.succeed("su -- testbed -c 'which jless'")
        '';
      };
    };
}
