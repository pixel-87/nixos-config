{ pkgs, ... }:
{
  imports = [
    ../../modules/home/profiles/dev.nix
  ];
  home.stateVersion = "25.05";

  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
