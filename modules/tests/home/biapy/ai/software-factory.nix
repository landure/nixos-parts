/**
  # biapy.ai.software-factory tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.ai.software-factory" = pkgs.testers.runNixOSTest {
        name = "biapy.ai.software-factory";

        nodes.machine =
          { pkgs, ... }:
          {
            imports = [
              inputs.home-manager.nixosModules.home-manager
              {
                # Linking the preset's skill packs (60+ skills, 200+
                # guides) takes longer than the default 5 minutes.
                systemd.services.home-manager-testbed = {
                  serviceConfig.TimeoutStartSec = pkgs.lib.mkForce "20min";
                };

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
                    inputs.self.homeModules.default
                  ];

                  biapy = {
                    ai.software-factory.enable = true;
                    mcp.context7.apiKey = "placeholder";
                    user.language = "english";
                  };

                  # The agents only write their skills folder when enabled.
                  # Stub/empty packages keep the test VM free of the agent binaries.
                  programs = {
                    opencode.enable = true;
                    opencode.package = pkgs.writeShellApplication {
                      name = "opencode";
                      text = "exit 0";
                    };
                    claude-code.enable = true;
                    claude-code.package = pkgs.writeShellApplication {
                      name = "claude";
                      text = "exit 0";
                    };
                    codex.enable = true;
                    codex.package = pkgs.writeShellApplication {
                      name = "codex";
                      text = "exit 0";
                    };
                    antigravity-cli.enable = true;
                    antigravity-cli.package = pkgs.writeShellApplication {
                      name = "antigravity-cli";
                      text = "exit 0";
                    };
                    github-copilot-cli.enable = true;
                    github-copilot-cli.package = pkgs.writeShellApplication {
                      name = "github-copilot-cli";
                      text = "exit 0";
                    };
                    sidecar.enable = true;
                    sidecar.package = pkgs.writeShellApplication {
                      name = "sidecar";
                      text = "exit 0";
                    };
                  };
                };
              }
            ];
          };

        testScript = ''
          # Linking the preset's 60+ skill packs makes the testbed boot take
          # longer than the 15 minute default.
          machine.wait_for_unit("default.target", timeout=1800)

          # Every skill pack the preset turns on lands in ~/.agents/skills
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/security-audit/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/clean-code-guard/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/hypothesis-debugging/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/api-designer/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/code-review/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/modern-web-guidance/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/planning-with-files/SKILL.md'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/ponytail/SKILL.md'")
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/architecture-decision-record-skill/SKILL.md'"
          )

          # The guard skills that are not in the preset default are absent
          machine.fail("su -- testbed -c 'test -e ~/.agents/skills/wp-guard/SKILL.md'")
        '';
      };
    };
}
