/**
  # biapy.programs.sidecar tests
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.sidecar" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.sidecar";

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
                  ../../../../home/_biapy/programs/sidecar.nix
                ];
                biapy = {
                  programs.sidecar = {
                    enable = true;
                    settings = {
                      foo = "bar";
                    };
                  };
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")
          machine.succeed("su -- testbed -c 'which sidecar'")
          machine.succeed("su -- testbed -c 'grep -q \"foo\":\"bar\" ~/.config/sidecar/config.json'")
        '';
      };
    };
}
