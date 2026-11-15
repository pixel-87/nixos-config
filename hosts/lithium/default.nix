{
  config,
  lib,
  ...
}:

let
  nodeIP = "192.168.0.45";
  lanInterface = "enp3s0";
  apiPort = config.services.kubernetes.apiserver.securePort;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/nixos/roles/k8s/common.nix
    ../../modules/nixos/roles/k8s/control-plane.nix
    ../../modules/nixos/roles/k8s/worker.nix
    ../../modules/nixos/services/k3s/cilium.nix

    ../../modules/nixos/tailscale.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot = {
      enable = true;
      graceful = true;
    };

    kernelParams = [ "systemd.swap=0" ];
  };

  #home-manager.users.pixel = import ./home.nix;

  programs.dconf.enable = true;

  networking = {
    hostName = "lithium"; # Define your hostname.

    extraHosts = ''
      ${nodeIP} ${config.services.kubernetes.masterAddress}
    '';

    firewall = {
      enable = true;

      interfaces = {
        ${lanInterface} = {
          allowedTCPPorts = [
            apiPort
            config.services.kubernetes.kubelet.port
          ];
        };

        "mynet".allowedTCPPorts = [ apiPort ];

        "flannel.1".allowedTCPPorts = [ apiPort ];

        "cilium_host".allowedTCPPorts = [ 6443 ];
        "lxc+".allowedTCPPorts = [ 6443 ];
      };
      # Trust internal cluster interfaces to allow pod-to-pod communication
      trustedInterfaces = [
        "cni0"
        "flannel.1"
      ];

      checkReversePath = "loose";
      allowedTCPPorts = [
        22
        80
        443
        53
        6443
      ];
      allowedUDPPorts = [
        53
        8472
      ];
    };
  };
  #networking.firewall.allowedUDPPorts = [ ... ];

  services = {
    kubernetes = {
      apiserver.advertiseAddress = nodeIP;

      kubelet = {
        nodeIp = nodeIP;

        extraConfig = {
          systemReserved = {
            cpu = "250m";
            memory = "512Mi";
          };

          kubeReserved = {
            cpu = "750m";
            memory = "1536Mi";
          };
        };
      };
    };

    flannel = {
      iface = lanInterface;
      backend = {
        Type = "vxlan";
        Port = 8472;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pixel.group = "lithium";

  users.groups.lithium = { };

  swapDevices = lib.mkForce [ ];
  zramSwap.enable = lib.mkForce false;

  networking.defaultGateway = "192.168.0.1";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the OpenSSH daemon.
  services.openssh = {
    settings = {
      PermitRootLogin = "no";
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
