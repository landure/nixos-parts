/**
  # biapy.programs.anki tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.anki" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.anki";
        nodes.machine = { pkgs, ... }: {
          imports = [
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.homeManagerModules.sops
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
                  ../../../../home/_biapy/user/identity.nix
                  ../../../../home/_biapy/programs/anki.nix
                ];
                biapy.user = {
                  identity.email = "testbed@example.com";
                  secretsSopsFile = null;
                };
                biapy.programs.anki = {
                  enable = true;
                  profile.keyFile = pkgs.writeText "anki-key" "sync-key";
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")
          machine.succeed("su -- testbed -c 'which anki'")
          machine.succeed(
              "su -- testbed -c 'test -e \"$HOME/.local/share/Anki2/prefs21.db\"'"
          )
        '';
      };
    };
}
