{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.shell;
in
{
  options.myModules.shell = {
    enable = lib.mkEnableOption "zsh shell with starship prompt and modern CLI tools";

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "~/nixos-config";
      description = "Path to your NixOS flake for rebuild aliases";
    };

    enableNh = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the NH helper CLI and expose NH_FLAKE defaults";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      shellAliases = {
        # Safety
        rm = "rm -i";
        mv = "mv -i";
        cp = "cp -i";
        
        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        
        # Listing
        l = "eza -lh";
        la = "eza -lah";
        ll = "eza -lh";
        lla = "eza -lah";
        ls = "eza";
        
        # Utilities
        cat = "bat";
        find = "fd";
        grep = "rg";
        
        # Git
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git log --oneline -10";
        
        # System
        cpu = "top -o %CPU";
        mem = "top -o %MEM";
        
        # Quick edits
        zrc = "nvim ~/.zshrc";
        nix-config = "nvim ${cfg.flakePath}";

        # NixOS helpers: explicit switch aliases and build-only aliases
        switch-laptop = "sudo nixos-rebuild switch --flake ${cfg.flakePath}#laptop";
        switch-lithium = "sudo nixos-rebuild switch --flake ${cfg.flakePath}#lithium";
        switch = "sudo nixos-rebuild switch --flake ${cfg.flakePath}#$(hostname)";

        build-laptop = "sudo nixos-rebuild build --flake ${cfg.flakePath}#laptop";
        build-lithium = "sudo nixos-rebuild build --flake ${cfg.flakePath}#lithium";
        build = "sudo nixos-rebuild build --flake ${cfg.flakePath}#$(hostname)";
      };
      
      initContent = ''
        # History configuration
        HISTFILE=~/.histfile
        HISTSIZE=10000
        SAVEHIST=10000
        setopt HIST_IGNORE_DUPS
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_FIND_NO_DUPS
        setopt HIST_SAVE_NO_DUPS
        setopt SHARE_HISTORY
        
        # Directory navigation
        setopt AUTO_CD
        setopt PUSHD_IGNORE_DUPS
        
        # Completion
        setopt MENU_COMPLETE
        setopt AUTOMENU
        
        # Keybindings
        bindkey -e  # Emacs mode
        bindkey "^[[1;5C" forward-word  # Ctrl+Right
        bindkey "^[[1;5D" backward-word # Ctrl+Left
        
        # Show fastfetch on interactive shells (only once per login session)
        if [[ $- == *i* ]]; then
          marker="$XDG_RUNTIME_DIR/fastfetch_shown"
          if [[ -z "$XDG_RUNTIME_DIR" ]]; then
            marker="/tmp/fastfetch_shown"
          fi
          if [[ ! -f "$marker" ]]; then
            if command -v fastfetch >/dev/null 2>&1; then
              fastfetch
              mkdir -p "$(dirname "$marker")" 2>/dev/null || true
              : > "$marker"
            fi
          fi
        fi
      '';
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
        
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          format = "[$path]($style) ";
          style = "bold cyan";
        };
        
        git_branch = {
          format = "on [$symbol$branch]($style) ";
          symbol = " ";
          style = "bold purple";
        };
        
        git_status = {
          format = "[\\($all_status$ahead_behind\\)]($style) ";
          style = "bold red";
          conflicted = "🏳";
          ahead = "⇡$count";
          behind = "⇣$count";
          diverged = "⇕⇡$ahead_count⇣$behind_count";
          untracked = "🤷";
          stashed = "📦";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "✘";
        };
        
        cmd_duration = {
          min_time = 500;
          format = "took [$duration]($style) ";
          style = "bold yellow";
        };
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    home.sessionVariables = lib.mkIf cfg.enableNh {
      NH_FLAKE = cfg.flakePath;
      NH_OS_FLAKE = cfg.flakePath;
    };

    home.packages = with pkgs; [
      eza           # Better ls
      bat           # Better cat
      fd            # Better find
      ripgrep       # Better grep
      starship      # Shell prompt
      fzf           # Fuzzy finder
      opencode      # AI coding agent for the terminal
    ] ++ lib.optionals cfg.enableNh [ nh ];
  };
}
