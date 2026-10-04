{ pkgs, ... }:

{
  services.kubernetes = {
    masterAddress = "master.ed-thomas.local";
    apiserverAddress = "https://master.ed-thomas.local:6443";

    easyCerts = true;

    flannel = {
      enable = true;
      openFirewallPorts = false;
    };

    addons.dns = {
      enable = true;
      clusterIp = "10.96.0.10";
      clusterDomain = "cluster.local";
    };
  };

  environment.systemPackages = [ pkgs.kubectl ];
}
