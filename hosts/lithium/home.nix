{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home
    inputs.nixvim.homeModules.nixvim
    inputs.nix-index-database.homeModules.nix-index
  ];

  myModules = {
    cli.enable = true;
    shell.enable = true;
    git = {
      enable = true;
      userEmail = "edwardoliverthomas@gmail.com";
    };
  };

  home.stateVersion = "25.05";

}
