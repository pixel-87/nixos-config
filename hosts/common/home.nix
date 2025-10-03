{ inputs, config, pkgs, lib, ... }:

{
  home = {
    username = lib.mkDefault "pixel";
    homeDirectory = lib.mkDefault "/home/pixel";
    stateVersion = lib.mkDefault "24.05";
  };

  programs.home-manager.enable = true;
}
