/**
  # biapy.user.no-telemetry tests

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
      checks."biapy.user.no-telemetry" = pkgs.testers.runNixOSTest {
        name = "biapy.user.no-telemetry";

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
                  ../../../../home/_biapy/user/no-telemetry.nix
                ];
                biapy.user.no-telemetry.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # the opt-out variables are exported in the user session environment
          machine.succeed(
              "su -- testbed -c 'grep -qx DO_NOT_TRACK=1 ~/.nix-profile/etc/profile.d/hm-session-vars.sh'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -qx DISABLE_TELEMETRY=1 ~/.nix-profile/etc/profile.d/hm-session-vars.sh'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -qx TELEMETRY_OPTOUT=1 ~/.nix-profile/etc/profile.d/hm-session-vars.sh'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -qx PIP_DISABLE_PIP_VERSION_CHECK=1 ~/.nix-profile/etc/profile.d/hm-session-vars.sh'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -qx NO_UPDATE_NOTIFIER=1 ~/.nix-profile/etc/profile.d/hm-session-vars.sh'"
          )
        '';
      };
    };
}
