{ config, pkgs, ... }: 
{
  services.k3s = {
    enable = true;
    role = "server";
  };

  environment.systemPackages = [ pkgs.kubernetes-helm ];

  networking.firewall = {
    allowedTCPPorts = [ 6443 ];
    allowedUDPPorts = [ 8472 ];
  };
}
