{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
 
    home-manager = {
     url = "github:nix-community/home-manager";
     inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  

  outputs = { nixpkgs, home-manager, firefox-addons, lanzaboote, hyprland, ... }@inputs: 

    let
      mkNixosSystem = { system, modules }: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = modules ++ [
          { nixpkgs.hostPlatform = system; }
        ];
      };
    in
    {
      nixosConfigurations = {

        laptop = mkNixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/laptop/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.pixel = import ./hosts/laptop/home.nix {
                pkgs = nixpkgs.legacyPackages.${system}; 
                lib = nixpkgs.lib;
                configs = {};
              };
            }  
          ];
        };
        lithium = mkNixosSystem {
          system = "x86_64-linux";
          modules = [];
        };
      };

      #homeConfigurations = let
      #  pkgs-x86 = nixpkgs.legacyPackages."x86_64-linux";
      #  in {
      #    
      #  };

    };
}
