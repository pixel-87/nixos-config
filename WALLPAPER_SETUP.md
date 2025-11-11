# Wallpaper Switcher Setup

A comprehensive wallpaper management system using `swww` with best-practice organization.

## Features

- ✨ Smooth wallpaper transitions with customizable animations
- 🖱️ Visual wallpaper picker with fzf
- ⌨️ Keyboard shortcuts for cycling wallpapers
- 💾 Persistent wallpaper memory (remembers last used)
- 🎨 QuickShell widget for visual selection
- 📁 Organized cache system for thumbnails
- 🚀 Fast daemon-based switching

## Installation

The wallpaper system is automatically included when you rebuild your configuration:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
home-manager switch --flake .#<username>@<hostname>
```

## Usage

### Keyboard Shortcuts

Add these to your Hyprland bindings (already configured):

- `Super+Alt+W` - Open interactive wallpaper picker (fzf)
- `Super+Ctrl+Right` - Next wallpaper
- `Super+Ctrl+Left` - Previous wallpaper

### Command Line

```bash
# Set a specific wallpaper with fade transition
wallpaper-switcher set /home/pixel/wallpapers/wallpaper.png fade

# Cycle to next wallpaper
wallpaper-switcher next

# Cycle to previous wallpaper
wallpaper-switcher prev

# Pick wallpaper interactively (requires fzf)
wallpaper-switcher pick

# List all available wallpapers
wallpaper-switcher list

# Show current wallpaper
wallpaper-switcher current
```

### Available Transitions

- `random` - Random transition effect
- `simple` - Plain fade
- `fade` - Fade between wallpapers
- `wipe` - Wipe effect
- `cw` - Clockwise transition
- `ccw` - Counter-clockwise transition
- `wave` - Wave transition

## Files

- `modules/home/wallpaper.nix` - Main wallpaper module with scripts
  - `wallpaper-switcher` - Main control script
  - `wallpaper-init` - Initialization script for Hyprland startup

- `modules/home/hyprland/quickshell/components/Wallpaper.qml` - Visual QuickShell widget

## Wallpaper Directory

Store your wallpapers in:
```
~/wallpapers/
```

Supported formats: PNG, JPG, JPEG

## How It Works

1. **Daemon Management**: `wallpaper-init` starts the swww daemon on Hyprland startup
2. **Persistent State**: Last selected wallpaper is cached in `~/.cache/wallpaper-switcher/`
3. **Thumbnails**: Thumbnails are generated and cached for faster loading
4. **Transitions**: Smooth animations provide visual feedback when switching
5. **Integration**: Seamless Hyprland keybinding integration

## Customization

### Change Keybindings

Edit `/home/pixel/nixos-config/modules/home/hyprland/hyprland.nix` and modify the keybinds in the bind array.

### Change Wallpaper Directory

Edit the `WALLPAPER_DIR` in `wallpaper-switcher` or set the environment variable:
```bash
export WALLPAPER_DIR=/path/to/wallpapers
```

### Change Default Transition

Modify the default transition type in wallpaper management scripts or pass it explicitly:
```bash
wallpaper-switcher set /path/to/wallpaper.png wipe
```

### Add to QuickShell Bar

The `Wallpaper.qml` component can be integrated into your main QuickShell bar for a visual switcher panel.

## Troubleshooting

### Wallpapers not showing up

1. Ensure wallpapers are in `~/wallpapers/` directory
2. Check file permissions: `chmod 644 ~/wallpapers/*`
3. Verify supported format (PNG, JPG, JPEG)

### swww daemon not starting

```bash
# Manual daemon start
swww-daemon

# Check if running
pgrep -x swww-daemon

# View logs
journalctl -u home-manager-hyprland.service
```

### fzf picker not working

Install fzf if missing:
```bash
nix-shell -p fzf
# or add to home modules
```

## Performance Notes

- Daemon mode keeps memory footprint low (~10-20MB)
- Thumbnails cached after first generation
- Transitions are GPU-accelerated
- No performance impact on other applications

