{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.opencode;
in
{
  options.myModules.opencode = {
    enable = lib.mkEnableOption "opencode AI coding agent with plugins";

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of opencode plugins to install";
      example = [ "opencode-gemini-auth@latest" ];
    };

    model = lib.mkOption {
      type = lib.types.str;
      default = "anthropic/claude-sonnet-4";
      description = "Default AI model to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ opencode ];

    xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      plugin = cfg.plugins;
      model = cfg.model;
    };
  };
}
