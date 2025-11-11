{ configs, pkgs, lib, ... }:

{
  imports = [
    ../../modules/home/profiles/dev.nix
    ../../modules/home/hyprland/hyprland.nix
    ../../modules/home/font.nix
    ../../modules/home/firefox.nix
    ../../modules/home/quickshell.nix
  ];


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
      xfce.thunar
      brightnessctl
      wireplumber
      openssh
      onedrive
      qmk
      obsidian
      zotero
    ];
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    PATH = "$HOME/.local/bin:$PATH";
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
        search = "fuzzy";
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
      #"org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
      #"org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
    };
  };

  


}
