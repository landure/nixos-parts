/**
  # biapy.console.web tests

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
      checks."biapy.console.web" = pkgs.testers.runNixOSTest {
        name = "biapy.console.web";

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
                  ../../../../home/_biapy/console/web.nix
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/programs/ddgr.nix
                  ../../../../home/_biapy/programs/nom.nix
                ];
                biapy.console.web.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which curl'")
          machine.succeed("su -- testbed -c 'which monolith'")
          machine.succeed("su -- testbed -c 'which russ'")
          machine.succeed("su -- testbed -c 'which tuifeed'")
          machine.succeed("su -- testbed -c 'which wget'")
          machine.succeed("su -- testbed -c 'which wiki-tui'")
        '';
      };
    };
}
