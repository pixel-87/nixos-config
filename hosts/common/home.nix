{ inputs, config, pkgs, lib, ... }:

{
  home = {
    username = "pixel";
    homeDirectory = "/home/pixel";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
