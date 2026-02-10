{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/home
    ../../modules/home/profiles/dev-gui.nix
    ../../modules/home/hyprland/hyprland.nix
    ../../modules/home/font.nix
    ../../modules/home/firefox.nix
    ../../modules/home/noctalia.nix
    inputs.nixvim.homeModules.nixvim
  ];

  # Enable Hyprland module
  myModules.hyprland.enable = true;

  # Configure git
  myModules.git.userEmail = "edwardoliverthomas@gmail.com";

  # Enable pentesting tools
  myModules.pentesting.enable = true;
  myModules.fastfetch.enable = true;
  myModules.starship.enable = true;

  home = {
    username = "pixel";
    homeDirectory = "/home/pixel";
    stateVersion = "25.05";

    packages = with pkgs; [
      sbctl
      git
      home-manager
      wl-clipboard
      playerctl
      protonvpn-gui
      nautilus
      brightnessctl
      wireplumber
      openssh
      onedrive
      obsidian
      zotero
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
    SHELL = "${pkgs.fish}/bin/fish";
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
    # fastfetch.enable = true;
    firefox.enable = true;
    kitty = {
      enable = true;
      enableGitIntegration = true;
      font.name = "Maple Mono NF";
      font.size = 12;
      themeFile = "tokyo_night_night";
      extraConfig = ''
        confirm_os_window_close 0
        background_opacity 0.85
        background_blur 1
        
        # Enable color support
        term xterm-256color
        
        # Nerd Font symbol mappings
        symbol_map U+E0A0-U+E0A3,U+E0B0-U+E0BF,U+E0C0-U+E0C8,U+E0CA,U+E0CC-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B1,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F372,U+F400-U+F532,U+F0001-U+F1AF0 Symbols Nerd Font Mono
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
      };

      # Styling
      style = builtins.readFile ../../modules/home/styles/wofi.css;
    };
    btop.enable = true;
    #Thunar.enable = true;
  };

  services = {
    # Using Noctalia's built-in notifications and wallpaper
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
