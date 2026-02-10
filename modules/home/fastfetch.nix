{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.fastfetch;
in
{
  options.myModules.fastfetch = {
    enable = lib.mkEnableOption "fastfetch with custom config";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos";
          type = "auto";
          height = 2;
          padding = {
            top = 1;
          };
        };
        # general settings removed: "multithreading" is not a valid option
        display = {
          size = {
            binaryPrefix = "si";
          };
          color = "blue";
          separator = "  ";
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "shell"
          "display"
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "font"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "locale"
          "break"
          "colors"
        ];
      };
    };
  };
}
