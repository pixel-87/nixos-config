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
      options = "--delete-older-than 40d --optimise";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Pin upower to 1.91.3: nixpkgs 1.91.4 installs empty
  # etc/systemd/system/upower.service and
  # share/dbus-1/system-services/org.freedesktop.UPower.service files,
  # which makes systemd report "Unit upower.service is masked" and aborts
  # switch-to-configuration with status 4. Required here because
  # services.tuned.ppdSupport forces services.upower.enable.
  # Remove once nixpkgs ships a fixed upower (> 1.91.4).
  nixpkgs.overlays = [
    (final: prev: {
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
