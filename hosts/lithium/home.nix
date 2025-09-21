{ pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix  
    ../../modules/home/vim.nix  
  ];

  home = {
  username = "lithium";
  homeDirectory = "/home/lithium";
  stateVersion = "25.05";
  };

  home.packages = with pkgs; [
  ];

}
