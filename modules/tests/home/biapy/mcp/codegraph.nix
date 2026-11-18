/**
  # biapy.mcp.codegraph tests

  - [Testing Modules @ Nix-Book](https://ekala-project.github.io/nix-book/ch09-08-testing-modules.html).
  - [Integration testing with NixOS virtual machines @ nix.dev](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html).
*/
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks."biapy.mcp.codegraph" = pkgs.testers.runNixOSTest {
        name = "biapy.mcp.codegraph";

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
                  ../../../../home/_biapy/mcp/codegraph.nix
                  ../../../../home/_biapy/programs/ast-grep.nix
                  ../../../../home/_biapy/skills/stark-ai-de-agent-skills.nix
                ];
                biapy = {
                  ai.skills.enable = true;
                  mcp.codegraph.enable = true;
                };

                # The MCP servers are only written when MCP is enabled.
                programs.mcp.enable = true;
              };
            }
          ];
        };

        testScript = ''
          machine.wait_for_unit("default.target")

          # The codegraph binary is installed
          machine.succeed("su -- testbed -c 'which codegraph'")
          machine.succeed("su -- testbed -c 'codegraph --version'")

          # The MCP server is registered
          machine.succeed("su -- testbed -c 'test -e ~/.config/mcp/mcp.json'")
          machine.succeed(
              "su -- testbed -c 'grep -q \"codegraph\" ~/.config/mcp/mcp.json'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -q \"serve\" ~/.config/mcp/mcp.json'"
          )
          machine.succeed(
              "su -- testbed -c 'grep -q -- \"--mcp\" ~/.config/mcp/mcp.json'"
          )

          # ast-grep is pulled in as a dependency
          machine.succeed("su -- testbed -c 'which ast-grep'")
          machine.succeed("su -- testbed -c 'test -e ~/.agents/skills/ast-grep/SKILL.md'")

          # The codegraph-ast-grep agent skill is installed
          machine.succeed(
              "su -- testbed -c 'test -e ~/.agents/skills/codegraph-ast-grep/SKILL.md'"
          )
        '';
      };
    };
}
