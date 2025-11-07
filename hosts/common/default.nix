{ inputs, config, pkgs, lib, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAUlSYYn21KaUPynSPSyDcc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7jPmlASv++d3dLS6GdeMa8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/gsjPGN0g7geCnybSrMvEPLgM24="
      ];
    };

    #gc = {
    #  automatic = true;
    #  dates = "weekly";
    #  options = "--delete-older-than 7d";
    #};
  };

  #nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
  ];


  system.stateVersion = lib.mkDefault "25.05";
}
