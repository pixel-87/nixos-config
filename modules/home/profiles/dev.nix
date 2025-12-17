{ pkgs, ... }:

{
  imports = [
    ../shell.nix
    ../git.nix
    ../vim.nix
    ../neovim.nix
  ];

  # Enable modules via their options
  myModules = {
    shell.enable = true;
    git.enable = true;
    vim.enable = true;
    neovim.enable = true;
  };

  programs.gh.enable = true;
}
