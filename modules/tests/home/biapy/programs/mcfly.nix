/**
  # biapy.programs.mcfly tests

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
      checks."biapy.programs.mcfly" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.mcfly";

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
                  ../../../../home/_biapy/programs/mcfly.nix
                ];
                biapy.programs.mcfly.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.succeed(
              "su -- testbed -c 'grep -q '^MCFLY_PROMPT=' ~/.nix-profile/etc/profile.d/hm-session-vars.sh'"
          )
        '';
      };
    };
}
