{ self, lib, ... }:

{
  perSystem =
    { system, ... }:
    {
      checks =
        lib.mapAttrs' (name: cfg: lib.nameValuePair name cfg.config.system.build.toplevel) (
          lib.filterAttrs (_: cfg: cfg.pkgs.stdenv.hostPlatform.system == system) self.nixosConfigurations
        )
        // {
          # Boot the laptop's Neovim config headlessly (catches require() errors).
          nvim = self.nixosConfigurations.laptop.config.home-manager.users.pixel.programs.nixvim.build.test;
        };
    };
}
