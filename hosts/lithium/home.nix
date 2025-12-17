{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ../../modules/home/profiles/dev.nix
    inputs.nixvim.homeModules.nixvim
  ];
  home.stateVersion = "25.05";

  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  home.packages = with pkgs; [
    cargo
    rustc
    nodejs
    gcc
    tree-sitter
  ];
}
