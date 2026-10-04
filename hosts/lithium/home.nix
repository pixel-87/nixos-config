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
  ];

  myModules = {
    # Keep server CLI workflow enabled.
    cli.enable = true;
    shell.enable = true;
    tmux.enable = true;
    git = {
      enable = true;
      userEmail = "edwardoliverthomas@gmail.com";
    };
  };

  home.stateVersion = "25.05";

}
