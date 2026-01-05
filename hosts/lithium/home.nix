{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ../../modules/home
    ../../modules/home/profiles/dev.nix
    inputs.nixvim.homeModules.nixvim
  ];
  
  # Configure git
  myModules.git.userEmail = "edwardoliverthomas@gmail.com";
  
  home.stateVersion = "25.05";

  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
