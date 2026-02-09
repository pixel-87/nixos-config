{ config, pkgs, ... }:
{

  imports = [
    ../services/k3s/cert-manager.nix
    ../services/k3s/longhorn.nix
  ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=0644"
      "--disable=servicelb"
      "--node-ip=192.168.0.40"
    ];
  };

  environment.systemPackages = with pkgs; [
    kubernetes-helm
    fluxcd
  ];

  networking.firewall = {
    allowedTCPPorts = [ 6443 ];
    allowedUDPPorts = [ 8472 ];
  };
}
