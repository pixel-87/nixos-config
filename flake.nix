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
  };

  

  outputs = { nixpkgs, home-manager, firefox-addons, ... }@inputs: 

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      root =./.;
      lib = pkgs.lib;
    in
    {
      nixosConfigurations = builtins.listToAttrs [
        {
          name = "laptop";
          value = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {inherit inputs root; };
            modules = [
              ./hosts/laptop/default.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.users.pixel = import ./hosts/laptop/home.nix {
                  pkgs = pkgs;
                  lib = lib;
                  configs = {};
                };
              }  
	    ];
	  };
        }
      ];
    };
}
