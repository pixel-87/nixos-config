{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.myModules.egm;

  # OpenCode resolves paths in a SKILL.md relative to the directory containing
  # it. EGM's skills read the plugin's shared personas and document standards,
  # so each skill needs those trees beside it. Installing skills/ alone leaves
  # `agents/<persona>.md` and `resources/document_standards/` dangling.
  skills = pkgs.runCommand "egm-opencode-skills" { } ''
    mkdir -p $out
    cp -R ${inputs.elephant-goldfish-model}/skills/. $out/
    chmod -R u+w $out
    for skill in $out/egm-*/; do
      cp ${inputs.elephant-goldfish-model}/agents/*.md "$skill/agents/"
      cp -R ${inputs.elephant-goldfish-model}/resources "$skill/resources"
    done
  '';
in
{
  options.myModules.egm.enable = lib.mkEnableOption "Google Elephant-Goldfish Model skills for OpenCode";

  config = lib.mkIf cfg.enable {
    xdg.configFile."opencode/skills".source = skills;
  };
}
