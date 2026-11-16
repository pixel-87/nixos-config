{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
    ../../modules/nixos/profiles/gui.nix
    ../../modules/nixos/tailscale.nix
  ];

  # Pin upower to 1.91.3: nixpkgs 1.91.4 installs empty
  # etc/systemd/system/upower.service and
  # share/dbus-1/system-services/org.freedesktop.UPower.service files,
  # which makes systemd report "Unit upower.service is masked" and aborts
  # switch-to-configuration with status 4. Required here because
  # services.tuned.ppdSupport forces services.upower.enable.
  # Remove once nixpkgs ships a fixed upower (> 1.91.4).
  nixpkgs.overlays = [
    (_: prev: {
      upower = prev.upower.overrideAttrs (_: rec {
        version = "1.91.3";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "upower";
          repo = "upower";
          rev = "v${version}";
          hash = "sha256-QdAJxaua43iGovQeRg+n1MypS5CS0Ro3gqF9Tv8eMBg=";
        };
      });
    })
  ];

  # Bootloader.
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 15;
    };

    loader.systemd-boot.enable = false;

    kernelModules = [
      "sdhci"
      "sdhci-pci"
    ];

    kernelParams = [
      "resume=UUID=896ab1c6-052c-49d5-8f91-e6a83065cfd6"
      "resume_offset=18919424"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {
    tuned = {
      # enabled in modules/nixos/common.nix
      ppdSupport = true;
      ppdSettings.main.battery_detection = true;
    };

    logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandleLidSwitchDocked = "ignore";
      KillUserProcesses = false;
    };

    # Enable OneDrive background sync service
    onedrive.enable = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30min";
  };

  # Exeter, UK location
  location.latitude = 50.7256;
  location.longitude = -3.5275;

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
