{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.cli;
in
{
  options.myModules.cli = {
    enable = lib.mkEnableOption "CLI tools and enhancements";
  };

  config = lib.mkIf cfg.enable {
    # --- Programs with Home Manager Modules ---

    # Smarter cd
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ]; # Replace cd with zoxide
    };

    # Better find
    programs.fd = {
      enable = true;
      hidden = true;
      ignores = [ ".git/" ];
    };

    # Fuzzy finder
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      # Use fd for fzf to respect .gitignore and be faster
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
    };

    # Git TUI
    programs.lazygit.enable = true;

    # Per-directory environment variables
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Index of files in Nix packages (command-not-found replacement)
    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    # Grep alternative
    programs.ripgrep.enable = true;

    # --- Packages ---

    home.packages = with pkgs; [
      comma # Run any binary: , cowsay hello
      nix-tree # Browse dependencies of Nix derivations
      nvd # Diff two Nix generations
      dust # Graphical disk usage (du alternative)
      procs # Modern process viewer (ps alternative)
      tldr # Simplified man pages
    ];

    # --- Aliases ---

    home.shellAliases = {
      du = "dust";
      ps = "procs";
    };

    # Build nix-index database on first activation
    home.activation.nix-index = ''
      if [ ! -f "$HOME/.cache/nix-index/files" ]; then
        $DRY_RUN_CMD mkdir -p "$HOME/.cache/nix-index"
      fi
    '';
  };
}
