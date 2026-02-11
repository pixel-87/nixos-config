{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.hyprland;
in
{
  options.myModules.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager configuration";

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal emulator";
    };

    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "gb";
      description = "Keyboard layout for Hyprland";
    };

    gapsIn = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Inner gaps between windows";
    };

    gapsOut = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Outer gaps from screen edges";
    };

    borderSize = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = "Window border size";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        exec-once = [
          "nm-applet --indicator"
          "blueman-applet"
          cfg.terminal
        ];
        monitor = [ ",preferred,auto,1" ];

        input = {
          kb_layout = cfg.keyboardLayout;
          follow_mouse = 1;
        };

        device = [
          {
            name = "diego-palacios-cantor";
            kb_layout = "us";
          }
          {
            name = "diego-palacios-cantor-keyboard";
            kb_layout = "us";
          }
          {
            name = "diego-palacios-cantor-system-control";
            kb_layout = "us";
          }
          {
            name = "diego-palacios-cantor-consumer-control";
            kb_layout = "us";
          }
        ];

        general = {
          gaps_in = cfg.gapsIn;
          gaps_out = cfg.gapsOut;
          border_size = cfg.borderSize;
          "col.active_border" = "rgba(ffffffee)";
          "col.inactive_border" = "rgba(595959aa)";
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 8;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = false;
            xray = false;
          };
        };

        animations = {
          enabled = true;

          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];

          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, F1, exec, show-keybinds"
          "$mainMod, space, exec, toggle-float"

          "$mainMod, Q, exec, ${cfg.terminal}"
          "$mainMod, C, killactive"
          "$mainMod, M, exit"
          "$mainMod, E, exec, nautilus"
          "$mainMod, V, togglefloating"
          "$mainMod, R, exec, noctalia-shell ipc call launcher toggle"
          "$mainMod, P, pseudo"
          "$mainMod, X, togglesplit"
          "$mainMod, F, exec, zen"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, h, movefocus, l"
          "$mainMod, j, movefocus, d"
          "$mainMod, k, movefocus, u"
          "$mainMod, l, movefocus, r"

          "$mainMod, left, alterzorder, top"
          "$mainMod, right, alterzorder, top"
          "$mainMod, up, alterzorder, top"
          "$mainMod, down, alterzorder, top"
          "$mainMod, h, alterzorder, top"
          "$mainMod, j, alterzorder, top"
          "$mainMod, k, alterzorder, top"
          "$mainMod, l, alterzorder, top"

          "CTRL ALT, up, exec, hyprct dispatch focuswindow floating"
          "CTRL ALT, down, exec, hyprct dispatch focuswindow tiled"

          "$mainMod CTRL, c, movetoworkspace, empty"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"
          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, j, movewindow, d"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, l, movewindow, r"

          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPause, exec, playerctl play-pause"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioPrev, exec, playerctl previous"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = toString (i + 1);
              keycode = "code:1${toString i}";
            in
            [
              "$mainMod, ${keycode}, workspace, ${ws}"
              "$mainMod SHIFT, ${keycode}, movetoworkspacesilent, ${ws}"
            ]
          ) 9
        ))
        ++ [
          "$mainMod SHIFT, P, exec, screenshot area"
          "$mainMod CTRL, P, exec, screenshot window"
          "$mainMod ALT, P, exec, screenshot edit"

          # Noctalia wallpaper controls
          "$mainMod ALT, W, exec, noctalia-shell ipc call wallpaper toggle"
          "$mainMod CTRL, right, exec, noctalia-shell ipc call wallpaper random"
          "$mainMod CTRL, left, exec, noctalia-shell ipc call wallpaper random"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindl = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
      };

      extraConfig = ''
        # Window rules for dedicated workspaces
        windowrule = opacity 0.95 0.75, match:class .*
      '';
    };
  };
}
