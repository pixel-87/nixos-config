{ lib, inputs, ... }:

{
  imports = [
    ./default.nix
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
  ];

  home = {
    stateVersion = lib.mkDefault "25.05";
  };

  programs.home-manager.enable = true;
}
