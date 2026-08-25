{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.tmux;
in
{
  options.myModules.tmux = {
    enable = lib.mkEnableOption "Tmux terminal multiplexer" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      shortcut = "a";

      # Start window and pane indexing at 1 (matches keyboard 1-9 layout)
      baseIndex = 1;

      # Enable mouse mode (scrolling, clicking tabs/panes, resizing)
      mouse = true;

      terminal = "screen-256color";
      escapeTime = 0; # Instant Esc key response, useful for vi keystuff
      historyLimit = 50000; # Generous scrollback buffer

      # Use Vi keybindings in copy mode
      keyMode = "vi";

      extraConfig = ''
        # --- Community Standard Keybindings ---

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # Keep current path when creating new windows
        bind c new-window -c "#{pane_current_path}"

        # Vim-style pane selection (h, j, k, l)
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Resizing panes with Shift + Vim keys
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        # Quick config reload (Prefix + r)
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded!"

        # Vi copy mode keybindings (v to select, y to copy)
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
      '';
    };
  };
}
