/**
  # Tirith

  Tirith intercepts suspicious URLs, ANSI injection,
  and pipe-to-shell attacks before they execute.

  ## 🛠️ Tech Stack

  - [Tirith homepage](https://tirith.sh/)
    ([Tirith @ GitHub](https://github.com/sheeki03/tirith)).

  ## 📝 Documentation

  ### 🏠 Home Manager

  - [programs.tirith @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tirith.enable).
  - [programs.tirith @ NixOS reference](https://search.nixos.org/options?source=home_manager&query=programs.tirith.).

  ## 🙇 Acknowledgements

  - [Tirith Policy Cookbook](https://github.com/sheeki03/tirith/blob/main/docs/cookbook.md).
  - [Policy templates @ Tirith's GitHub](https://github.com/sheeki03/tirith/tree/main/crates/tirith/assets/policy_templates).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf mkOptionDefault;
  inherit (lib.options) mkEnableOption;

  cfg = config.biapy.programs.tirith;

in
{
  options = {
    biapy.programs.tirith.enable = mkEnableOption "tirith";
  };

  config = mkIf cfg.enable {
    programs.tirith = {
      enable = mkDefault true;

      package = mkDefault pkgs.biapy-parts.tirith;

      policy = mkDefault {
        version = mkOptionDefault 1;

        # Fail mode: "closed" — if tirith cannot evaluate a command it blocks rather
        # than allowing it. An enterprise should never silently let an unanalysed
        # command run on a managed machine.
        fail_mode = mkOptionDefault "closed";

        # Paranoia level (1-4): 3 — high detection sensitivity across the org.
        paranoia = mkOptionDefault 3;

        # Disable the `TIRITH=0` bypass entirely — interactive AND non-interactive.
        # In a managed fleet a bypass is a permanent hole, so neither form is permitted.
        allow_bypass_env = mkOptionDefault false;
        allow_bypass_env_noninteractive = mkOptionDefault false;

        # Require explicit acknowledgement for warn findings.
        strict_warn = mkOptionDefault true;

        # Raise the severity (risk) of the highest-risk remote-execution, registry, and
        # supply-chain rules so they are unmistakable in logs and reports. NOTE:
        # severity_overrides only escalate severity — they do NOT by themselves force a
        # block. The action_overrides block below (shortened_url, curl_pipe_shell,
        # wget_pipe_shell) is what forces those rules to block.
        severity_overrides = mkOptionDefault {
          shortened_url = mkOptionDefault "HIGH";
          plain_http_to_sink = mkOptionDefault "CRITICAL";
          curl_pipe_shell = mkOptionDefault "CRITICAL";
          wget_pipe_shell = mkOptionDefault "CRITICAL";
          pipe_to_interpreter = mkOptionDefault "HIGH";
          docker_untrusted_registry = mkOptionDefault "HIGH";
          git_typosquat = mkOptionDefault "HIGH";
          threat_package_typosquat = mkOptionDefault "CRITICAL";

          mcp_insecure_server = mkOptionDefault "HIGH";
          mcp_untrusted_server = mkOptionDefault "HIGH";
          mcp_overly_permissive = mkOptionDefault "HIGH";
          mcp_suspicious_args = mkOptionDefault "HIGH";
          mcp_server_drift = mkOptionDefault "HIGH";
        };

        # Force specific rules to always block, regardless of their default action.
        # Only "block" is supported (escalation can upgrade, never downgrade).
        action_overrides = mkOptionDefault {
          shortened_url = mkOptionDefault "block";
          curl_pipe_shell = mkOptionDefault "block";
          wget_pipe_shell = mkOptionDefault "block";
          mcp_untrusted_server = mkOptionDefault "block";
          mcp_overly_permissive = mkOptionDefault "block";
        };

        # URL / host patterns that always pass analysis. Keep this list short and
        # reviewed — every entry is a trusted hole in the fleet.
        allowlist = mkOptionDefault [
          # "raw.githubusercontent.com"
          # "homebrew.bintray.com"
          # "get.docker.com"
        ];

        # URL / host patterns that are always blocked (overrides allowlist).
        blocklist = mkOptionDefault [ ];

        # `tirith scan` configuration. fail_on sets the severity threshold at which a
        # scan exits non-zero — wire this into your build / pre-merge gate.
        scan = mkOptionDefault {
          fail_on = mkOptionDefault "high";

          # MCP server names the organization trusts. Keep this tight — a trusted name
          # silences every per-server MCP config finding and exempts the server from
          # drift detection. Generate from `tirith mcp policy init`.
          # trusted_mcp_servers = [];

          # Per-server allowed tools — a guardrail against an agent or a merge
          # smuggling a new MCP tool past the lockfile. See `tirith mcp policy init`.
          # mcp_allowed_tools = {
          #   my-trusted-server = [ "read-only" ];
          # };

        };

        # Per-agent governance (enforcement).
        # An enterprise typically declares the callers it expects (CI provider, the
        # sanctioned coding agent) and denies everything else by review. A `deny`
        # match forces the verdict to Block and appends an `agent_denied_by_policy`
        # finding; `deny` beats any matching `allow`, and `allow` is NOT a bypass — a
        # verdict the engine already blocked stays blocked. `tirith agent sessions`
        # shows the AgentOrigins your fleet actually sees.
        # agent_rules = {
        #   allow = [
        #     {
        #       kind = "ci";
        #       name = "github-actions";
        #     }
        #     {
        #       kind = "agent";
        #       name = "claude-code";
        #     }
        #     {
        #       kind = "mcp";
        #       name = "claude-code";
        #     }
        #   ];
        #   deny = [];
        # };

        # Package-policy section. UNLIKE the other templates, the enterprise
        # template ships this block ACTIVE (uncommented) with strict defaults: an
        # enterprise wants supply-chain gates enforced out of the box, not opt-in.
        # Tune the thresholds to your risk tolerance.
        package_policy = mkOptionDefault {
          block_not_found = mkOptionDefault true; # block on registry HTTP 404 (--online only)
          block_newer_than_days = mkOptionDefault 7; # reject brand-new packages (<= 7 days old)
          warn_newer_than_days = mkOptionDefault 30; # warn on recently-published packages
          warn_low_downloads_below = mkOptionDefault 1000; # warn on low-reputation packages
          block_install_scripts_for_unknown_packages = mkOptionDefault true; # block Unknown + script signal
          block_typosquat_distance = mkOptionDefault 1; # block one-character typosquats
          block_aggregate_score = mkOptionDefault 60; # stricter than the baseline of 76
          warn_aggregate_score = mkOptionDefault 40; # surface risk earlier than the baseline 51
          block_osv_min_cvss = mkOptionDefault 7.0; # any OSV >= this CVSS escalates to Block
          block_repo_mismatch = mkOptionDefault true; # elevate `package_repo_mismatch` to Block
          warn_install_script_network_call = mkOptionDefault true; # keep the install-script signal on
          block_dependency_confusion = mkOptionDefault true; # keep dep-confusion at Block
          internal_package_names = mkOptionDefault [ ]; # [{ ecosystem: npm, name: "@my-co/*" }]
          repo_mismatch_check_max_packages = mkOptionDefault 50; # cap on packages checked under --online
        };
      };
    };
  };
}
