/**
  # biapy.ai.mcp-servers tests

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
      checks."biapy.ai.mcp-servers" = pkgs.testers.runNixOSTest {
        name = "biapy.ai.mcp-servers";

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
                  ../../../../home/_biapy/ai/mcp-servers.nix
                  ../../../../home/_biapy/ai/skills.nix
                  ../../../../home/_biapy/mcp/codegraph.nix
                  ../../../../home/_biapy/mcp/context7.nix
                  ../../../../home/_biapy/programs/ast-grep.nix
                  ../../../../home/_biapy/programs/rtk.nix
                  ../../../../home/_biapy/skills/stark-ai-de-agent-skills.nix
                ];
                biapy.ai.mcp-servers.enable = true;
                biapy.mcp.context7.apiKey = "test-key";
              };
            }
          ];
        };

        testScript = ''
          machine.succeed("su -- testbed -c 'which mcp-nixos'")
          machine.succeed("su -- testbed -c 'which mcp-server-git'")
          machine.succeed("su -- testbed -c 'which mcp-server-fetch'")
          machine.succeed("su -- testbed -c 'which mcp-server-filesystem'")
          machine.succeed("su -- testbed -c 'which mcp-language-server'")
          machine.succeed("su -- testbed -c 'which mcp'")
        '';
      };
    };
}
