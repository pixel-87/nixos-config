{ configs, pkgs, lib, ... }:

{
  imports = [
    (import ../../modules/home)
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
    ];
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
      '';
    };
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          font = "Maple Mono NF 11";
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "clock" "cpu" "memory" "temperature"];
          modules-right = [ "pulseaudio" "battery" "network#speed" ];
        };
      };  
    };
    wofi.enable = true;
    gh.enable = true;
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
