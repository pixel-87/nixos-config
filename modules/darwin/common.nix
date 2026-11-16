{ pkgs, ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@admin"
      ];
    };

    gc = {
      automatic = true;
      interval = [
        {
          Weekday = 7;
          Hour = 3;
          Minute = 15;
        }
      ];
      options = "--delete-older-than 40d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # This option defines the first nix-darwin release used on this machine.
  # Set it once on install and never change it afterwards.
  system.stateVersion = 7;

  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    sops
    age
  ];
}
