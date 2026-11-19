/**
  # biapy.programs.ssh tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.ssh" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.ssh";

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
                  ../../../../home/_biapy/programs/ssh.nix
                ];
                biapy.programs.ssh.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The ssh helpers are installed
          machine.succeed("su -- testbed -c 'which passh'")
          machine.succeed("su -- testbed -c 'which passh-copy-id'")

          # The helpers expose their version
          machine.succeed("su -- testbed -c 'passh --version'")
          machine.succeed("su -- testbed -c 'passh-copy-id --version'")

          # The helpers report the usage
          machine.succeed("su -- testbed -c 'passh --help'")
          machine.succeed("su -- testbed -c 'passh-copy-id --help'")

          # The ssh configuration is generated
          machine.succeed("su -- testbed -c 'test -e ~/.ssh/config'")

          # The helpers run the same ssh client as the ssh program,
          # and force public key authentication off.
          machine.succeed(
              "su -- testbed -c 'passh -G localhost | grep -qx \"pubkeyauthentication false\"'"
          )
          machine.succeed(
              "su -- testbed -c 'passh -G localhost | grep -qx \"preferredauthentications keyboard-interactive,password\"'"
          )
        '';
      };
    };
}
