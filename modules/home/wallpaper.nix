{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    swww
    imagemagick
    libjxl
  ];

  home.file.".local/share/wallpapers/.gitkeep".text = "";

  xdg.configHome = "${config.home.homeDirectory}/.config";

  # Script to manage wallpaper switching
  home.file.".local/bin/wallpaper-switcher" = {
    executable = true;
    text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          WALLPAPER_DIR="''${WALLPAPER_DIR:-$HOME/nixos-config/assets/wallpapers}"
          CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-switcher"
          CURRENT_WALLPAPER_FILE="$CACHE_DIR/current"

          mkdir -p "$CACHE_DIR"

          # Function to set wallpaper with transition (fast path)
          set_wallpaper() {
            local wallpaper="$1"
            local transition="''${2:-none}"
            local duration="''${3:-1}"

            if [[ ! -f "$wallpaper" ]]; then
              echo "Error: Wallpaper not found: $wallpaper"
              return 1
            fi

            swww img "$wallpaper" --transition-type="$transition" --transition-duration="$duration" 2>/dev/null
            echo "$wallpaper" > "$CURRENT_WALLPAPER_FILE"
          }

          # Function to list available wallpapers
          list_wallpapers() {
            find "$WALLPAPER_DIR" -maxdepth 1 -type f -iname "*.png" | sort
          }

          # Function to cycle to next wallpaper
          cycle_next() {
            local wallpapers=($(list_wallpapers))
            if [[ ''${#wallpapers[@]} -eq 0 ]]; then
              echo "Error: No wallpapers found in $WALLPAPER_DIR"
              return 1
            fi

            local current=""
            if [[ -f "$CURRENT_WALLPAPER_FILE" ]]; then
              current=$(cat "$CURRENT_WALLPAPER_FILE")
            fi

            local next_index=0
            for i in "''${!wallpapers[@]}"; do
              if [[ "''${wallpapers[$i]}" == "$current" ]]; then
                next_index=$(( (i + 1) % ''${#wallpapers[@]} ))
                break
              fi
            done

            set_wallpaper "''${wallpapers[$next_index]}" "none" "1"
          }

          # Function to cycle to previous wallpaper
          cycle_prev() {
            local wallpapers=($(list_wallpapers))
            if [[ ''${#wallpapers[@]} -eq 0 ]]; then
              echo "Error: No wallpapers found in $WALLPAPER_DIR"
              return 1
            fi

            local current=""
            if [[ -f "$CURRENT_WALLPAPER_FILE" ]]; then
              current=$(cat "$CURRENT_WALLPAPER_FILE")
            fi

            local prev_index=0
            for i in "''${!wallpapers[@]}"; do
              if [[ "''${wallpapers[$i]}" == "$current" ]]; then
                prev_index=$(( (i - 1 + ''${#wallpapers[@]}) % ''${#wallpapers[@]} ))
                break
              fi
            done

            set_wallpaper "''${wallpapers[$prev_index]}" "none" "1"
          }

          # Function to pick wallpaper with fzf
          pick_wallpaper() {
            local wallpapers=($(list_wallpapers))
            if [[ ''${#wallpapers[@]} -eq 0 ]]; then
              echo "Error: No wallpapers found in $WALLPAPER_DIR"
              return 1
            fi

            local selected
      selected=$(printf '%s\n' "''${wallpapers[@]}" | xargs -I {} basename {} | fzf --preview "/run/current-system/sw/bin/file '$WALLPAPER_DIR/{}' && echo && /run/current-system/sw/bin/ls -lh '$WALLPAPER_DIR/{}'" --preview-window=right:30%)
            
            if [[ -n "$selected" ]]; then
              set_wallpaper "$WALLPAPER_DIR/$selected" "none" "1"
            fi
          }

          # Parse arguments
          case "''${1:-help}" in
            set)
              set_wallpaper "$2" "''${3:-random}"
              ;;
            next)
              cycle_next
              ;;
            prev)
              cycle_prev
              ;;
            pick)
              pick_wallpaper
              ;;
            list)
              list_wallpapers
              ;;
            current)
              if [[ -f "$CURRENT_WALLPAPER_FILE" ]]; then
                cat "$CURRENT_WALLPAPER_FILE"
              else
                echo "No current wallpaper set"
              fi
              ;;
            *)
              cat << EOF
      Usage: wallpaper-switcher <command> [options]

      Commands:
        set <path> [transition]  Set wallpaper with optional transition (default: random)
        next                     Switch to next wallpaper
        prev                     Switch to previous wallpaper
        pick                     Pick wallpaper interactively with fzf
        list                     List all available wallpapers
        current                  Show current wallpaper
        help                     Show this help message

      Transitions: random, simple, fade, wipe, cw, ccw, wave

      Examples:
        wallpaper-switcher set /home/pixel/wallpapers/wallpaper.png fade
        wallpaper-switcher next
        wallpaper-switcher pick
      EOF
              ;;
          esac
    '';
  };

  # Script to initialize swww daemon
  home.file.".local/bin/wallpaper-init" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      WALLPAPER_DIR="''${WALLPAPER_DIR:-$HOME/nixos-config/assets/wallpapers}"
      CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-switcher"
      CURRENT_WALLPAPER_FILE="$CACHE_DIR/current"

      mkdir -p "$CACHE_DIR"

      # Start swww daemon if not running
      if ! pgrep -x "swww-daemon" > /dev/null; then
        swww-daemon
        sleep 1
      fi

      # Set initial wallpaper
      if [[ -f "$CURRENT_WALLPAPER_FILE" ]]; then
        # Use last set wallpaper
        swww img "$(cat "$CURRENT_WALLPAPER_FILE")" 2>/dev/null || true
      else
        # Use first available wallpaper
        local first_wallpaper=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f -iname "*.png" | sort | head -1)
        if [[ -n "$first_wallpaper" ]]; then
          swww img "$first_wallpaper"
        fi
      fi
    '';
  };
}
