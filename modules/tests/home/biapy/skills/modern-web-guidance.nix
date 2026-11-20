/**
  # biapy.skills.modern-web-guidance tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.skills.modern-web-guidance" = pkgs.testers.runNixOSTest {
        name = "biapy.skills.modern-web-guidance";

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
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/skills/modern-web-guidance.nix
                ];
                biapy = {
                  ai.skills.enable = true;
                  skills.modern-web-guidance.enable = true;
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The skills are installed in ~/.agents/skills
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/modern-web-guidance/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/chrome-extensions/SKILL.md'")

          # The guides are installed alongside SKILL.md
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/modern-web-guidance/guides/css/css-layout.md'"
          )

          # The CLI is on the PATH
          machine.succeed("su -- testbed -c 'command -v modern-web-guidance'")

          # The CLI searches the offline index
          machine.succeed(
              "su -- testbed -c 'modern-web-guidance search \"light dismiss dialog\" | grep -q light-dismiss-a-dialog'"
          )

          # The CLI retrieves a guide
          machine.succeed(
              "su -- testbed -c 'modern-web-guidance retrieve light-dismiss-a-dialog | grep -q \"Light-Dismiss a Dialog\"'"
          )

          # The SKILL.md calls the packaged CLI instead of npx
          machine.succeed(
              "su -- testbed -c '! grep -q npx ~/.agents/skills/modern-web-guidance/SKILL.md'"
          )
        '';
      };
    };
}
