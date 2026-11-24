/**
  # biapy.dev.dev-environments tests

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
      checks."biapy.dev.dev-environments" = pkgs.testers.runNixOSTest {
        name = "biapy.dev.dev-environments";

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
                  ../../../../home/_biapy/dev/dev-environments.nix
                  ../../../../home/_biapy/programs/cargo.nix
                  ../../../../home/_biapy/programs/go.nix
                  ../../../../home/_biapy/programs/mise.nix
                ];
                biapy.dev.dev-environments.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which devbox'")
          machine.succeed("su -- testbed -c 'which devenv'")
          machine.succeed("su -- testbed -c 'which devcontainer'")
          machine.succeed("su -- testbed -c 'which mise'")
          machine.succeed("su -- testbed -c 'which direnv'")
        '';
      };
    };
}
