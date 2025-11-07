{ config, pkgs, lib, ... }:
let
  terminal = "kitty";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
      exec-once = [
        "swww init"
        #"sww img ~/wallpapers/art.png"
        "waybar"
      ];
      monitor = [",preferred,auto,1" ];

      input = {
        kb_layout = "gb";

	# moving the mouse to another screen highlights that screen
	follow_mouse = 1;
};

device = [
  {
    name = "diego-palacios-cantor-keyboard";
    kb_layout = "us";
  }
];
      
      general = {
	gaps_in = 5;
	gaps_out = 10;
	border_size = 2;
      };

      animations.enabled = true;

      dwindle = {
	pseudotile = true;
	preserve_split = true;
      };
      
      #gestures.workspace_swipe = true;

      "$mainMod" = "SUPER";
   
      bind = [
        # Frost-pheonix on github has good binds
        "$mainMod, F1, exec, show-keybinds"
        "$mainMod, space, exec, toggle-float"

        

	"$mainMod, Q, exec, ${terminal}"
	"$mainMod, C, killactive"
	"$mainMod, M, exit"
	"$mainMod, E, exec, thunar"
	"$mainMod, V, togglefloating"
	"$mainMod, R, exec, wofi --show drun || pkill wofi"
	"$mainMod, P, pseudo" # dwindle
	"$mainMod, X, togglesplit" # dwindle

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

	# Example special workspace (scratchpad)
	"$mainMod, S, togglespecialworkspace, magic"
	"$mainMod SHIFT, S, movetoworkspace, special:magic"

	# Scroll through existing workspaces with mainMod + scroll
	"$mainMod, mouse_down, workspace, e+1"
	"$mainMod, mouse_up, workspace, e-1"

	# Move/reize windows with mainMod + LMB/RMB and dragging

        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, l, movewindow, r"

	# Laptop multimedia keys for volume and LCD brightness
	", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
	", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
	", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
	", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

	# Requires playerctl
	",XF86AudioNext, exec, playerctl next"
	",XF86AudioPause, exec, playerctl play-pause"
	",XF86AudioPlay, exec, playerctl play-pause"
	",XF86AudioPrev, exec, playerctl previous"



      ]
      ++ (
        # Workspaces: $mainMod + [1-9] and shift variants
        builtins.concatLists (builtins.genList (i:
          let
            ws = toString (i +1);
            keycode = "code:1${toString i}";
          in [
            "$mainMod, ${keycode}, workspace, ${ws}"
            "$mainMod SHIFT, ${keycode}, movetoworkspacesilent, ${ws}"
          ])
          9)
      );
      
      bindm = [
	"$mainMod, mouse:272, movewindow"
	"$mainMod, mouse:273, resizewindow"
      ];

      bindl  = [
	",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
	",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
    };
  };
}
