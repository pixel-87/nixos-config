{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

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
        "@wheel"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d --optimise";
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  # Extend sudo timeout for better UX
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=15
    Defaults timestamp_type=global
  '';

  environment.systemPackages = with pkgs; [
    wget
    curl
    sops
    age
  ];

  system.stateVersion = lib.mkDefault "25.05";
}
