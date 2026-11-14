{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/tailscale.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;

  hardware.graphics.enable = true;

  # Bootloader.
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote.configurationLimit = 15;

  boot.kernelModules = [
    "sdhci"
    "sdhci-pci"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];
  boot.kernelParams = [
    "resume=UUID=896ab1c6-052c-49d5-8f91-e6a83065cfd6"
    "resume_offset=18919424"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30min";
  };

  # Exeter, UK location
  location.latitude = 50.7256;
  location.longitude = -3.5275;

  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    KillUserProcesses = false;
  };
  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
  };

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  users.users.pixel.extraGroups = [ "networkmanager" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable OneDrive background sync service
  services.onedrive.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
