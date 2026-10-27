{ lib, pkgs, ... }:

{
  services.kubernetes.flannel.enable = false;
  services.flannel.enable = false;

  services.kubernetes.apiserver.allowPrivileged = true;

  virtualisation.containerd.settings.plugins."io.containerd.grpc.v1.cri".cni = {
    bin_dir = lib.mkForce "/var/lib/cni/bin";
    conf_dir = "/var/lib/cni/net.d";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/cni/bin 0755 root root -"
    "d /var/lib/cni/net.d 0755 root root -"
    "L+ /var/lib/cni/bin/loopback - - - - ${pkgs.cni-plugins}/bin/loopback"
  ];
}
