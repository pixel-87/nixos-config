{ inputs, ... }:

let
  inherit (inputs) nixpkgs home-manager;

  sharedModules = [ 
    ./common

    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };

        users.pixel = import ./common/home.nix;
      };
    }
  ];

  mkNixosSystem = hostname: extraModules:
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = sharedModules ++ [
        ./${hostname}
      ] ++ extraModules;
    };
  in
  {
    flake.nixosConfigurations = {
      laptop = mkNixosSystem "laptop" [];
      lithium = mkNixosSystem "lithium" [];
    };
  }
