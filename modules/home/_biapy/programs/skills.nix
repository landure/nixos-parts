{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool package;
  inherit (pkgs) fetchFromGitHub;

  cfg = config.biapy.programs.skills;

  vercelLabsSkills = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    tag = "v1.8.1";
    hash = "sha256-K4xCSpt8jnkTx8FDEa2cXrzMjpRkYOwTiFqPap6iCYU=";
  };

  findSkillsSkill = "${vercelLabsSkills}/skills/find-skills/SKILL.md";

  findSkillsContent = builtins.replaceStrings [ "npx skills" ] [ "skills" ] (
    builtins.readFile findSkillsSkill
  );

  skillsPackage =
    if cfg.telemetry.enable then
      cfg.package
    else
      pkgs.symlinkJoin {
        name = "skills-no-telemetry";
        paths = [ cfg.package ];
        postBuild = ''
          mkdir -p "$out/bin"
          for bin in ${cfg.package}/bin/*; do
            name=$(basename "$bin")
            cat > "$out/bin/$name" <<EOF
          #!/usr/bin/env bash
          DISABLE_TELEMETRY=1 DO_NOT_TRACK=1 exec ${cfg.package}/bin/$name "\$@"
          EOF
            chmod +x "$out/bin/$name"
          done
        '';
      };
in
{
  options.biapy.programs.skills = {
    enable = mkEnableOption "Vercel Labs' skills";

    package = mkOption {
      type = package;
      default = pkgs.skills;
      description = "The skills package to install.";
    };

    withSkill = mkOption {
      type = bool;
      default = true;
      description = "Install the find-skills agent skill.";
    };

    telemetry.enable = mkOption {
      type = bool;
      default = false;
      description = "Allow the skills tool to send telemetry. When disabled, the tool is wrapped to set DISABLE_TELEMETRY and DO_NOT_TRACK.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      skillsPackage
    ];

    biapy.ai.skills.skills = mkIf cfg.withSkill {
      find-skills = mkDefault findSkillsContent;
    };
  };
}
