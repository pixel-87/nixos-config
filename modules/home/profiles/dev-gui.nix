{ pkgs, ... }:

{
  imports = [
    ./dev.nix
    ../wallpaper.nix
  ];

  home.packages = with pkgs; [
    vscode
    libreoffice-qt6
    antigravity-ide-fhs
    android-studio
  ];
}
