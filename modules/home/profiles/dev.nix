{pkgs, ... }:

{
  imports = [
    ../shell.nix
    ../git.nix
    ../vim.nix
    ../wallpaper.nix
  ];

  home.packages = with pkgs; [
    vscode
    libreoffice-qt6-fresh
  ];

  programs.gh.enable = true;
}
