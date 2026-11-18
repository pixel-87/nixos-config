{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.alacritty;
in
{
  options.myModules.alacritty = {
    enable = lib.mkEnableOption "Alacritty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      package = pkgs.alacritty;

      settings = {
        font = {
          normal.family = "Maple Mono NF";
          size = 12;
        };

        window = {
          opacity = 0.85;
          padding = {
            x = 6;
            y = 6;
          };
        };
      };
    };
  };
}
