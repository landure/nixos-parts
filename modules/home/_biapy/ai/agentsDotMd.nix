/**
  # AGENTS.md

  This module defines AGENTS.md.

  It installs AGENTS.md in `~/.agents/skills`
  and in supported agents skills folders.

  ## 🛠️ Tech Stack

  - [AGENTS.md homepage](https://agents.md/)
    ([AGENTS.md @ GitHub](https://github.com/agentsmd/agents.md)).
*/
{
  config,
  lib,
  ...
}:
let
  inherit (lib.attrsets) attrNames genAttrs;
  inherit (lib.lists) filter optional;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.strings) optionalString;
  inherit (lib.trivial) min;
  inherit (lib.types)
    attrsOf
    bool
    lines
    listOf
    oneOf
    str
    ;

  cfg = config.biapy.ai.agentsDotMd;

  supportedAgents = [
    {
      name = "opencode";
      target = ".config/opencode/AGENTS.md";
    }
  ];

  # Render a structured attrset to markdown:
  # attribute names are titles (h1..h6 by nesting depth, `_` is the first paragraph).
  renderAgentsDotMd =
    contents:
    let
      renderParagraph =
        value:
        if builtins.isString value then
          value
        else if builtins.isList value then
          builtins.concatStringsSep "\n" (map toString value)
        else if builtins.isAttrs value then
          ""
        else
          toString value;

      heading =
        level: name:
        builtins.concatStringsSep "" [
          (builtins.concatStringsSep "" (builtins.genList (_: "#") (min level 6)))
          " "
          name
        ];

      renderAttrs =
        level: attrs:
        let
          firstParagraph = optional (attrs ? "_") (renderParagraph attrs._);
          sections = map (name: renderSection level name attrs.${name}) (
            attrNames (removeAttrs attrs [ "_" ])
          );
        in
        builtins.concatStringsSep "\n\n" (filter (chunk: chunk != "") (firstParagraph ++ sections));

      renderSection =
        level: name: value:
        let
          body = if builtins.isAttrs value then renderAttrs (level + 1) value else renderParagraph value;
        in
        heading level name + optionalString (body != "") ("\n\n" + body);
    in
    ''
      # ${cfg.title}

      ${renderAttrs 2 contents + "\n"}
    '';

  # home.file creator: one AGENTS.md per supported agent.
  mkAgentsDotMdFiles =
    agents: content:
    genAttrs (map (agent: agent.target) agents) (_: {
      text = mkDefault content;
    });
in
{
  options = {
    biapy.ai.agentsDotMd = {
      enable = mkEnableOption "Biapy agent skills";
      title = mkOption {
        type = str;
        default = "Global Instructions";
        description = ''
          Global AGENTS.md H1 title
        '';
      };
      contents = mkOption {
        type = attrsOf (oneOf [
          lines
          (listOf lines)
          (attrsOf (oneOf [
            lines
            (listOf lines)
            (attrsOf (oneOf [
              lines
              (listOf lines)
              (attrsOf (oneOf [
                lines
                (listOf lines)
                (attrsOf (oneOf [
                  lines
                  (listOf lines)
                ]))
              ]))
            ]))
          ]))
        ]);
        default = {
          _ = [
            ''
              Applies across projects.
              Be brief. Use precise technical terms.
            ''
          ];
        };
        description = ''
          Global AGENTS.md prompt organised by sections.
        '';
      };
    };
    programs = genAttrs (map (agent: agent.name) supportedAgents) (agent: {
      biapy.enableAgentsDotMd = mkOption {
        type = bool;
        default = true;
        description = "Enable biapy AGENTS.md integration for ${agent}.";
      };
    });
  };

  config = mkIf (cfg.enable && (cfg.contents != { })) {
    home.file = mkAgentsDotMdFiles (filter (
      agent:
      (config.programs.${agent.name}.enable && config.programs.${agent.name}.biapy.enableAgentsDotMd)
    ) supportedAgents) (renderAgentsDotMd cfg.contents);
  };
}
