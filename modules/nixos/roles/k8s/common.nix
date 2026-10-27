{ pkgs, ... }:

{
  services.kubernetes = {
    masterAddress = "master.ed-thomas.local";
    apiserverAddress = "https://master.ed-thomas.local:6443";

    easyCerts = true;

    flannel = {
      enable = false;
      openFirewallPorts = false;
    };

    addons.dns = {
      enable = true;
      clusterIp = "10.0.0.254";
      clusterDomain = "cluster.local";
    };
  };

  environment.systemPackages = [ pkgs.kubectl ];
}
