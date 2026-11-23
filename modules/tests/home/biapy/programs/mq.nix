/**
  # biapy.programs.mq tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.programs.mq" = pkgs.testers.runNixOSTest {
        name = "biapy.programs.mq";

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
                  ../../../../home/_biapy/programs/mq.nix
                ];
                biapy = {
                  ai.skills.enable = true;
                  programs.mq.enable = true;
                };
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The mq binaries are installed
          machine.succeed("su -- testbed -c 'which mq'")
          machine.succeed("su -- testbed -c 'mq --version'")
          machine.succeed("su -- testbed -c 'which mq-crawl'")

          # The agent skills are installed
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/processing-markdown/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/web-scraping/SKILL.md'")

          # mq actually processes markdown
          machine.succeed(
              "su -- testbed -c 'printf \"# Title\\n\" | mq \".h\" | grep -q \"# Title\"'"
          )
        '';
      };
    };
}
