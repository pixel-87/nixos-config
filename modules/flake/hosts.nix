{
  self,
  inputs,
  lib,
  ...
}:

let
  mkHost =
    name:
    lib.nixosSystem {
      specialArgs = { inherit inputs self; };

      modules = [
        ../../modules/nixos/common.nix
        ../../hosts/${name}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "hm-backup";
            users.pixel.imports = [
              ../../modules/home/common.nix
              ../../hosts/${name}/home.nix
            ];
          };
        }
      ];
    };
in
{
  flake.nixosConfigurations = lib.genAttrs [ "laptop" "lithium" "tungsten" ] mkHost;
}
