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

    # Local Linux VM builder, so x86_64-linux derivations can be built without
    # a remote machine. On Apple Silicon this runs the builder through Rosetta;
    # install it once with:
    #   softwareupdate --install-rosetta --agree-to-license
    linux-builder.enable = true;
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
