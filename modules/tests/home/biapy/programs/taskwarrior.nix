/**
  # biapy.programs.taskwarrior tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.taskwarrior" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.taskwarrior";

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
                  ../../../../home/_biapy/programs/taskwarrior.nix
                ];
                biapy.programs.taskwarrior.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")
          machine.succeed("su -- testbed -c 'which task'")
          machine.succeed("su -- testbed -c 'which taskwarrior-tui'")

          # The generated configuration is included by the user taskrc.
          machine.succeed(
              "su -- testbed -c 'grep -q home-manager-taskrc ~/.config/task/taskrc'"
          )

          # Taskwarrior is usable and stores its data in the XDG data home.
          machine.succeed(
              "su -- testbed -c 'test \"$(task _get rc.data.location)\" = \"$HOME/.local/share/task\"'"
          )
          machine.succeed(
              "su -- testbed -c 'test -d ~/.local/share/task'"
          )
        '';
      };
    };
}
