{
  config,
  lib,
  pkgs,
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
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.graceful = true;
  boot.kernelParams = ["systemd.swap=0"];

  #home-manager.users.lithium = import ./home.nix;

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

  time.timeZone = "Europe/London";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pixel = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = [ ];
  };

  swapDevices = lib.mkForce [ ];
  zramSwap.enable = lib.mkForce false;

  networking.defaultGateway = "192.168.0.1";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
