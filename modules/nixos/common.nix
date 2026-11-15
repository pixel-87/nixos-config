{ pkgs, lib, ... }:

{
  # --- Nix ---------------------------------------------------------------
  nix = {
    package = pkgs.lixPackageSets.stable.lix;

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

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (_: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })

      # Pin upower to 1.91.3: nixpkgs 1.91.4 installs empty
      # etc/systemd/system/upower.service and
      # share/dbus-1/system-services/org.freedesktop.UPower.service files,
      # which makes systemd report "Unit upower.service is masked" and aborts
      # switch-to-configuration with status 4. Required here because
      # services.tuned.ppdSupport forces services.upower.enable.
      # Remove once nixpkgs ships a fixed upower (> 1.91.4).
      (_: prev: {
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
  };

  # --- Boot --------------------------------------------------------------
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Locale ------------------------------------------------------------
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

  console.keyMap = "uk";

  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    openssh.enable = true;

    tuned.enable = true;
  };

  # --- Users -------------------------------------------------------------
  users.users.pixel = {
    isNormalUser = true;
    description = "pixel";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

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

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any
  # reason, even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are
  # pulled from, so changing it will NOT upgrade your system - see
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do
  # that.
  #
  # This value being lower than the current NixOS release does NOT mean your
  # system is out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes
  # it would make to your configuration, and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = lib.mkDefault "25.05";
}
