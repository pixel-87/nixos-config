{ pkgs, ... }:

{
  imports = [
    ../bluetooth.nix
    ../stylix.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;

  hardware.graphics.enable = true;
}
