{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/gui.nix
  ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "tungsten";
  networking.networkmanager.enable = true;

  swapDevices = [ ];

  boot.kernelParams = [ "acpi=force" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.onedrive.enable = true;

  location.latitude = 50.7256;
  location.longitude = -3.5275;

  users.users.pixel.extraGroups = [ "networkmanager" ];

  environment.systemPackages = with pkgs; [
    openssh
  ];
}
