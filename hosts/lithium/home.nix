{ pkgs, ... }:
{
  imports = [
    ../../modules/home/profiles/dev.nix
  ];
  home.stateVersion = "25.05";
}
