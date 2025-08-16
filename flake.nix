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
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs; root = ./.; };
        modules = [
          ./hosts/laptop/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = { inherit inputs; };
              users.pixel = import ./hosts/laptop/home.nix;
            };
          }  
        ];
      };
    };
}
