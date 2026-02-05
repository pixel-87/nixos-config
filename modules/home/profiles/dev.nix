{ pkgs, ... }:

{
  # Enable modules via their options
  myModules = {
    cli.enable = true;
    shell.enable = true;
    git.enable = true;
    vim.enable = true;
    neovim.enable = true;
    starship.enable = true;
  };

  programs.gh.enable = true;

  # Common development packages
  home.packages = with pkgs; [
    cargo
    rustc
    nodejs
    gcc
    tree-sitter
  ];
}
