{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/home/profiles/dev.nix
    ../../modules/home/hyprland/hyprland.nix
    ../../modules/home/font.nix
    ../../modules/home/firefox.nix
    ../../modules/home/quickshell.nix
    inputs.nixvim.homeModules.nixvim
  ];

  # Enable Hyprland module
  myModules.hyprland.enable = true;

  home = {
    username = "pixel";
    homeDirectory = "/home/pixel";
    stateVersion = "25.05";

    packages = with pkgs; [
      sbctl
      git
      home-manager
      cargo
      rustc
      nodejs
      gcc
      tree-sitter
      wl-clipboard
      playerctl
      proton-vpn-gui
      nautilus
      brightnessctl
      wireplumber
      openssh
      onedrive
      qmk
      obsidian
      zotero
      youtube-music
      inputs.zen-browser.packages.${pkgs.system}.default
      # Screenshot tools
      grim
      slurp
      swappy
      jq
      gimp
      figma-linux
      libresprite
      inkscape
    ];
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    PATH = "$HOME/.local/bin:$PATH";
  };

  # Screenshot script
  home.file.".local/bin/screenshot" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      # Create screenshots directory if it doesn't exist
      SCREENSHOT_DIR="$HOME/screenshots"
      mkdir -p "$SCREENSHOT_DIR"

      # Generate filename with timestamp
      FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

      case "''${1:-area}" in
        area)
          # Area selection screenshot
          grim -g "$(slurp)" "$FILENAME"
          ;;
        screen)
          # Full screen screenshot
          grim "$FILENAME"
          ;;
        window)
          # Active window screenshot
          grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILENAME"
          ;;
        edit)
          # Take area screenshot and open in swappy for editing
          grim -g "$(slurp)" - | swappy -f -
          exit 0
          ;;
        *)
          echo "Usage: $0 [area|screen|window|edit]"
          echo "  area   - Select area to screenshot (default)"
          echo "  screen - Full screen screenshot"
          echo "  window - Active window screenshot"
          echo "  edit   - Select area and edit with swappy"
          exit 1
          ;;
      esac

      # Copy to clipboard
      wl-copy < "$FILENAME"

      # Send notification
      notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME"

      echo "Screenshot saved to: $FILENAME"
    '';
  };
  

  programs = {
    fastfetch.enable = true;
    firefox.enable = true;
    kitty= {
      enable = true; 
      enableGitIntegration = true;
      font.name = "Maple Mono NF";
      extraConfig = ''
        confirm_os_window_close 0
        background_opacity 0.85
        background_blur 1
      '';
    };


    wofi = {
      enable = true;
      settings = {
        # Layout and appearance
        width = 600;
        height = 400;
        orientation = "vertical";
        sort_order = "default";
        
        # Search
        insensitive = true;
        matching = "fuzzy";
        
        # Behavior
        show = "drun";
        hide_scroll = true;
        key_exit = "Escape";
        
        # Styling - requires CSS below
        style = "${pkgs.writeText "wofi-style.css" ''
          * {
            margin: 0;
            padding: 0;
            border: 0;
            font-family: "Maple Mono NF", monospace;
            font-size: 14px;
          }
          
          window {
            background-color: #1e1e2e;
            border: 2px solid #cdd6f4;
            border-radius: 8px;
          }
          
          #input {
            background-color: #313244;
            color: #cdd6f4;
            border-bottom: 2px solid #cdd6f4;
            padding: 10px;
            border-radius: 0;
            margin: 5px;
          }
          
          #scroll {
            margin: 5px;
          }
          
          #entry {
            padding: 10px;
            border-radius: 4px;
            margin: 5px 0;
            background-color: #313244;
            color: #cdd6f4;
          }
          
          #entry:selected {
            background-color: #89b4fa;
            color: #1e1e2e;
          }
          
          #entry:hover {
            background-color: #45475a;
          }
        ''}";
      };
    };
    btop.enable = true;
    #Thunar.enable = true;
  };

  services = {
    mako.enable = true;
    swww.enable = true;
    cliphist.enable = true;
    playerctld.enable = true;
  };


  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [ "hyprland" ];
      };
      "org.freedesktop.impl.portal.Screenshot" = {
        default = [ "hyprland" ];
      };
      #"org.freedesktop.impl.portal.ScreenCast" = {
      #  default = [ "hyprland" ];
      #};
    };
  };

  # Set Zen Browser as default browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      # Ensure the figma:// URI opens with the nix-provided figma package
      "x-scheme-handler/figma" = "figma-linux.desktop";
    };
  };

}
