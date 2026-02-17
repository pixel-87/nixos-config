{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

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
      inputs.pre-commit.follows = "hyprland/pre-commit-hooks";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    plugin-99 = {
      url = "github:ThePrimeagen/99";
      flake = false;
    };

    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      # 'flake' contains your system configurations (nixosConfigurations)
      flake = {
        nixosConfigurations = {
          laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/laptop
              ./hosts/common
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs; };
                  backupFileExtension = "hm-backup";
                  users.pixel.imports = [
                    ./hosts/common/home.nix
                    ./hosts/laptop/home.nix
                  ];
                };
              }
            ];
          };

          lithium = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/lithium
              ./hosts/common
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs; };
                  backupFileExtension = "hm-backup";
                  users.pixel.imports = [
                    ./hosts/common/home.nix
                    ./hosts/lithium/home.nix
                  ];
                };
              }
            ];
          };
        };
      };

      # 'perSystem' handles things that vary by architecture (devshells, formatters)
      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          # This effectively replaces shell.nix
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.git
              pkgs.neovim
            ];
          };

          formatter = pkgs.nixfmt-tree;
        };
    };
}
