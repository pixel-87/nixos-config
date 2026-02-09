{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  cfg = config.myModules.shell;

  commonAliases = {
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
    glp = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

    # System
    cpu = "top -o %CPU";
    mem = "top -o %MEM";

    # Quick edits
    nix-config = "nvim ${cfg.flakePath}";

    # NixOS helpers
    switch-laptop = "nixos-rebuild switch --flake ${cfg.flakePath}#laptop --sudo";
    switch-lithium = "nixos-rebuild switch --flake ${cfg.flakePath}#lithium --sudo";
    build-laptop = "nixos-rebuild build --flake ${cfg.flakePath}#laptop --sudo";
    build-lithium = "nixos-rebuild build --flake ${cfg.flakePath}#lithium --sudo";

    switch-system = "nixos-rebuild switch --flake ${cfg.flakePath}#${osConfig.networking.hostName} --sudo";
    build-system = "nixos-rebuild build --flake ${cfg.flakePath}#${osConfig.networking.hostName} --sudo";

    # Deep REPL access
    # This automatically opens the REPL for the current machine
    nrepl = "nix repl --file '<nixpkgs/nixos>' --arg configuration '{ imports = [ ./hosts/${osConfig.networking.hostName}/default.nix ]; }'";
    
    # Simpler REPL for Flakes
    frepl = "nix repl --expr 'let f = builtins.getFlake \"${cfg.flakePath}\"; in f.nixosConfigurations.${osConfig.networking.hostName}'";
  };
in
{
  options.myModules.shell = {
    enable = lib.mkEnableOption "fish shell with starship prompt and modern CLI tools";

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos-config";
      description = "Path to your NixOS flake for rebuild aliases";
    };

    enableNh = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the NH helper CLI and expose NH_FLAKE defaults";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAliases = commonAliases // {
        switch-os = "sudo nixos-rebuild switch --flake ${cfg.flakePath}#(hostname)";
        build = "sudo nixos-rebuild build --flake ${cfg.flakePath}#(hostname)";
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        # Fastfetch
        if status is-interactive
          set marker "$XDG_RUNTIME_DIR/fastfetch_shown"
          if test -z "$XDG_RUNTIME_DIR"
            set marker "/tmp/fastfetch_shown"
          end
          if not test -f "$marker"
            if type -q fastfetch
              fastfetch
              mkdir -p (dirname "$marker")
              touch "$marker"
            end
          end
        end
      '';
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    home.sessionVariables = 
      (lib.mkIf cfg.enableNh {
        NH_FLAKE = cfg.flakePath;
        NH_OS_FLAKE = cfg.flakePath;
      }) // {
        SHELL = "${pkgs.fish}/bin/fish";
      };

    home.packages =
      with pkgs;
      [
        eza # Better ls
        bat # Better cat
        fd # Better find
        ripgrep # Better grep
        fzf # Fuzzy finder
        opencode # AI coding agent for the terminal
      ]
      ++ lib.optionals cfg.enableNh [ nh ];
  };
}
