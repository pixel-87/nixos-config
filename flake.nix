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
      mkNixosSystem =  hostPath: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          hostPath
          ./hosts/common
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
	      backupFileExtension = "backup";
              users.pixel = {
                imports = [ 
                  ./hosts/common/home.nix
                  (hostPath + /home.nix)
                ]; 
              };
            };
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        laptop = mkNixosSystem ./hosts/laptop;
        lithium = mkNixosSystem ./hosts/lithium;
      };
    };
}
