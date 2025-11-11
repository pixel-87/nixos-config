{ inputs, config, pkgs, lib, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };

    #gc = {
    #  automatic = true;
    #  dates = "weekly";
    #  options = "--delete-older-than 7d";
    #};
  };

  #nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
  ];


  system.stateVersion = lib.mkDefault "25.05";
}
