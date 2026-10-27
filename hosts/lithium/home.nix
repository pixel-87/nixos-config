{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home/cli.nix
    ../../modules/home/shell.nix
    ../../modules/home/tmux.nix
    ../../modules/home/git.nix
    ../../modules/home/neovim.nix
    ../../modules/home/vim.nix
    inputs.nixvim.homeModules.nixvim
  ];

  myModules = {
    # Keep server CLI workflow enabled.
    cli.enable = true;
    shell.enable = true;
    tmux.enable = true;
    vim.enable = true;
    neovim.enable = true;
    git = {
      enable = true;
      userEmail = "edwardoliverthomas@gmail.com";
    };
  };

  home.stateVersion = "25.05";

}
