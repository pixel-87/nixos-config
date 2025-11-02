{pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode
    libreoffice-qt6-fresh
  ];

  programs.gh.enable = true;
}
