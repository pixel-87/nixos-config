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
          type = "auto";
          source = ../../assets/nixos_logo_1.webp;
          width = 32;
          height = 16;
          padding = {
            right = 4;
          };
        };
        display = {
          separator = "  ";
          color = {
            keys = "magenta";
            output = "white";
            title = "magenta";
            separator = "blue";
          };
        };
        modules = [
          {
            type = "title";
            format = "{user-name}@{host-name}";
          }
          {
            type = "custom";
            format = "────────────────────────────";
          }
          {
            type = "os";
            key = " ";
            format = "{name} {version}";
          }
          {
            type = "kernel";
            key = "󰌽 ";
            format = "{release}";
          }
          {
            type = "uptime";
            key = "󰅐 ";
          }
          {
            type = "packages";
            key = "󰏖 ";
          }
          {
            type = "shell";
            key = " ";
          }
          {
            type = "wm";
            key = " ";
          }
          {
            type = "terminal";
            key = " ";
          }
          {
            type = "cpu";
            key = "󰍛 ";
            format = "{name}";
          }
          {
            type = "gpu";
            key = "󰢮 ";
            format = "{name}";
          }
          {
            type = "memory";
            key = "󰘚 ";
          }
          {
            type = "disk";
            key = "󰋊 ";
            folders = [ "/" ];
          }
          {
            type = "custom";
            format = "────────────────────────────";
          }
          {
            type = "colors";
            symbol = "circle";
          }
        ];
      };
    };

    home.file.".config/fastfetch/logo/nixos_logo_1.webp".source = ../../assets/nixos_logo_1.webp;
  };
}
