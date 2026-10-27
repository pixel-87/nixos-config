{ config, ... }:

{
  services.tailscale.enable = true;

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [ 22 ];
    };
}
