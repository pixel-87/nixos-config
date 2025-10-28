{pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode
  ];

  programs.gh.enable = true;
}
