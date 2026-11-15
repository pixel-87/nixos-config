{ lib, inputs, ... }:

{
  imports = [
    ./default.nix
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
  ];

  home = {
    username = lib.mkDefault "pixel";
    homeDirectory = lib.mkDefault "/home/pixel";
    stateVersion = lib.mkDefault "25.05";
  };

  programs.home-manager.enable = true;
}
