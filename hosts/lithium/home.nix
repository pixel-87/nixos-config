{ pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix  
    ../../modules/home/vim.nix  
    ../../modules/home/shell.nix
    ../../modules/home/profiles/dev.nix
  ];

}
