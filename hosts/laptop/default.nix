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
    #inputs.home-manager.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  hardware.graphics.enable = true;

  # Bootloader.
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote.configurationLimit = 3;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];
  boot.kernelParams = [
    "resume=/swapfile"
    "resume_offset=18919424"
  ];

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  #services.logind.settings.Login = ''
  #  HandleHibernateKey = hibernate
  #  HandleLidSwitch = hibernate
  #  handleLidSwitchDocked = ignore
  #'';

  services.tuned = {
    enable = true;

    ppdSettings.main.battery_detection = true;
  };
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  users.users.pixel = {
    isNormalUser = true;
    description = "pixel";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    openssh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05"; # Dont change

}
