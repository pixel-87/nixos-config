{ configs, pkgs, lib, ... }:

#let
#  startUpScript = pkgs.writeShellScriptBin "start" ''
#    waybar &
#    swww init &
#
#    sleep 1
#  '';
#in
{
  imports = [
    ../../home/programs/git.nix
    #../../home/programs/firefox.nix
    ../../home/hyprland/hyprland.nix
  ];
  home = {
    username = "pixel";
    homeDirectory = "/home/pixel";
    stateVersion = "25.05";

    packages = with pkgs; [
      git
      vim
      home-manager
      wl-clipboard
      playerctl
    ];
  };
  programs = {
    firefox.enable = true;
    kitty.enable = true;
    waybar.enable = true;
    wofi.enable = true;
    gh.enable = true;
    #thunar.enable = true;
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

  # swww img ${./wallpaper.png} &
  #wayland.windowManager.hyprland.enable = true;
  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  settings = {
  #    exec-once = "${startUpScript}";
  #  }; 
  #};
  


}
