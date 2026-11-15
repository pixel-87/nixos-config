{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/gui.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    kernelParams = [ "acpi=force" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "tungsten";
  networking.networkmanager.enable = true;

  swapDevices = [ ];

  services.onedrive.enable = true;

  location.latitude = 50.7256;
  location.longitude = -3.5275;

  users.users.pixel.extraGroups = [ "networkmanager" ];

  environment.systemPackages = with pkgs; [
    openssh
  ];
}
