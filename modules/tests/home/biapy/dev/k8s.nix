/**
  # biapy.dev.k8s tests

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
      checks."biapy.dev.k8s" = pkgs.testers.runNixOSTest {
        name = "biapy.dev.k8s";

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
                  inputs.sofka.homeManagerModules.default
                  ../../../../home/_biapy/dev/k8s.nix
                  ../../../../home/_biapy/programs/k9s.nix
                ];
                biapy.dev.k8s.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which k9s'")
        '';
      };
    };
}
