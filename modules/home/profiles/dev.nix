{ pkgs, ... }:

{
  imports = [
    ../shell.nix
    ../git.nix
    ../vim.nix
    ../neovim.nix
    ../wallpaper.nix
  ];

  # Enable modules via their options
  myModules = {
    shell.enable = true;
    git.enable = true;
    vim.enable = true;
    neovim.enable = true;
  };

  home.packages = with pkgs; [
    vscode
    libreoffice-qt6-fresh
  ];

  programs.gh.enable = true;
}
