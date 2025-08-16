{ configs, pkgs, lib, ... }:

{
  imports = [
    ../../modules/home/programs/git.nix
    #../../home/programs/firefox.nix
    ../../modules/home/hyprland/hyprland.nix
    ../../modules/home/programs/vim.nix
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
    ];
  };
  programs = {
    fastfetch.enable = true;
    firefox.enable = true;
    kitty= {
      enable = true; 
      enableGitIntegration = true;
      extraConfig = ''
        confirm_os_window_close 0
      '';
    };
    waybar.enable = true;
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
