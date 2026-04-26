{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;

  imports = [
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
    ../../modules/nixos/bluetooth.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;

  hardware.graphics.enable = true;

  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote.configurationLimit = 15;

  networking.hostName = "tungsten";

  swapDevices = [ ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.enable = true;

  services.onedrive.enable = true;

  time.timeTime = "Europe/London";

  location.latitude = 50.7256;
  location.longitude = -3.5275;

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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  console.keyMap = "uk";

  users.users.pixel = {
    isNormalUser = true;
    description = "pixel";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    openssh
  ];

  system.stateVersion = "25.05";
}