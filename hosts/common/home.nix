{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/home
    ../../modules/home/profiles/dev.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

  home = {
    username = lib.mkDefault "pixel";
    homeDirectory = lib.mkDefault "/home/pixel";
    stateVersion = lib.mkDefault "25.05";

    packages = with pkgs; [
    ];
  };

  programs.home-manager.enable = true;
}
