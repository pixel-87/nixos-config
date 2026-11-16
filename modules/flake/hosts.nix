{
  self,
  inputs,
  lib,
  ...
}:

let
  # A host is the pair of a NixOS/darwin system module (hosts/<name>/default.nix)
  # and a Home Manager module (hosts/<name>/home.nix). Everything else about a
  # machine lives in those two files.
  mkHost =
    name:
    {
      class ? "nixos",
      arch ? "x86_64",
    }:
    let
      isDarwin = class == "darwin";

      system = "${arch}-${if isDarwin then "darwin" else "linux"}";

      evalSystem = if isDarwin then inputs.nix-darwin.lib.darwinSystem else lib.nixosSystem;

      homeManagerModule =
        if isDarwin then
          inputs.home-manager.darwinModules.home-manager
        else
          inputs.home-manager.nixosModules.home-manager;
    in
    evalSystem {
      inherit system;
      specialArgs = { inherit inputs self; };

      modules = [
        ../../modules/${class}/common.nix
        ../../hosts/${name}
        homeManagerModule
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

  # arch is the CPU part of the system string; class selects the eval function
  # and the modules/<class> directory. A darwin host looks like:
  #   macbook = { class = "darwin"; arch = "aarch64"; };
  hosts = {
    laptop = { };
    lithium = { };
    tungsten = { };

    silicon = {
      class = "darwin";
      arch = "aarch64";
    };
  };

  hostsOfClass = class: lib.filterAttrs (_: host: (host.class or "nixos") == class) hosts;
in
{
  flake.nixosConfigurations = lib.mapAttrs mkHost (hostsOfClass "nixos");
  flake.darwinConfigurations = lib.mapAttrs mkHost (hostsOfClass "darwin");
}
