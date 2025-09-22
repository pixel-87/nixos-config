{ pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix  
    ../../modules/home/vim.nix  
    ../../modules/home/shell.nix
    ../../modules/home/profiles/dev.nix
  ];

  home = {
  username = "lithium";
  homeDirectory = "/home/lithium";
  stateVersion = "25.05";
  };

  home.packages = with pkgs; [
  ];

}
