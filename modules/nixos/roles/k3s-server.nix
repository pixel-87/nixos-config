{ config, pkgs, ... }: 
{

  imports = [
    ../services/k3s/cert-manager.nix
  ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=0644"
    ];
  };

  environment.systemPackages = with pkgs; [
    kubernetes-helm 
  ];

  networking.firewall = {
    allowedTCPPorts = [ 6443 ];
    allowedUDPPorts = [ 8472 ];
  };
}
