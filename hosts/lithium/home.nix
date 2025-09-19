{ pkgs, ... }:
{
  imports = [
    ../..modules/home/programs/git.nix  
  ];

  home = {
  username = "lithium";
  homeDirectory = "/home/lithium";
  stateVersion = "25.05";
  };

  home.packages = with pkgs; [
  ];

}
