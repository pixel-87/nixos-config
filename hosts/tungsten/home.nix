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

  myModules.hyprland.enable = true;

  myModules.git.userEmail = "edwardoliverthomas@gmail.com";

  myModules.pentesting.enable = true;

  myModules.fastfetch.enable = true;
  myModules.starship.enable = true;

  myModules.opencode = {
    enable = true;
    plugins = [ "opencode-gemini-auth@latest" ];
  };

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
      proton-vpn
      nautilus
      brightnessctl
      wireplumber
      openssh
      obsidian
      zotero
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
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

  home.file.".local/bin/screenshot" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      SCREENSHOT_DIR="$HOME/screenshots"
      mkdir -p "$SCREENSHOT_DIR"

      FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

      case "''${1:-area}" in
        area)
          grim -g "$(slurp)" "$FILENAME"
          ;;
        screen)
          grim "$FILENAME"
          ;;
        window)
          grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x(.size[1])"')" "$FILENAME"
          ;;
        edit)
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

      wl-copy < "$FILENAME"

      notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME"

      echo "Screenshot saved to: $FILENAME"
    '';
  };

  programs = {
    firefox.enable = true;
    kitty = {
      enable = true;
      enableGitIntegration = true;
      font.name = "Maple Mono NF";
      font.size = 12;
      themeFile = "Catppuccin-Mocha";
      extraConfig = ''
        confirm_os_window_close 0
        background_opacity 0.85
        background_blur 1

        term xterm-256color

        symbol_map U+E0A0-U+E0A3,U+E0B0-U+E0BF,U+E0C0-U+E0C8,U+E0CA,U+E0CC-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B1,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F372,U+F400-U+F532,U+F0001-U+F1AF0 Symbols Nerd Font Mono
      '';
    };

    wofi = {
      enable = true;
      settings = {
        width = 600;
        height = 400;
        orientation = "vertical";
        sort_order = "default";

        insensitive = true;
        matching = "fuzzy";

        show = "drun";
        hide_scroll = true;
        key_exit = "Escape";
      };

      style = builtins.readFile ../../modules/home/styles/wofi.css;
    };
    btop.enable = true;
  };

  services = {
    cliphist.enable = true;
    playerctld.enable = true;
  };

  programs.onedrive = {
    enable = true;
    settings = {
      delay_inotify_processing = "true";
      inotify_delay = "15";
      force_session_upload = "true";
    };
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
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "x-scheme-handler/figma" = "figma-linux.desktop";
    };
  };
}
