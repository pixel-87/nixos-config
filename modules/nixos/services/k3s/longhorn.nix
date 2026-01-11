{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Longhorn requires specific system packages and kernel modules
  environment.systemPackages = with pkgs; [
    nfs-utils
    openiscsi
  ];

  # Enable iSCSI daemon (required for Longhorn)
  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${config.networking.hostName}";
  };

  # Ensure multipathd is disabled (can conflict with Longhorn)
  systemd.services.multipathd.enable = lib.mkForce false;

  # Longhorn needs these kernel modules
  boot.kernelModules = [ "iscsi_tcp" ];

  # Firewall rules for Longhorn
  networking.firewall = {
    allowedTCPPorts = [
      # Longhorn Manager
      9500
      # Longhorn Engine
      10250
    ];
  };
  # Ensure /var/lib/longhorn exists with proper permissions
  # Ensure /var/lib/longhorn exists and link iscsiadm to a standard path
  systemd.tmpfiles.rules = [
    "d /var/lib/longhorn 0750 root root -"
    "L+ /usr/local/bin/iscsiadm - - - - ${pkgs.openiscsi}/bin/iscsiadm"
  ];
}
