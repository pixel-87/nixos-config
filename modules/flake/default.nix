{ inputs, ... }:
{
  imports = [
    ./hosts.nix
    ./checks/check-build.nix
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        # Formatting is enforced by the pre-commit check.
        flakeCheck = false;

        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          shfmt.enable = true;
        };
      };

      formatter = config.treefmt.build.wrapper;

      devShells.default = pkgs.mkShell {
        packages =
          with pkgs;
          [
            just
            nil
          ]
          ++ config.pre-commit.settings.enabledPackages;

        shellHook = config.pre-commit.shellHook;
      };

      pre-commit = {
        settings = {
          package = pkgs.prek;

          hooks = {
            # Formatters first; everything else runs concurrently after.
            treefmt = {
              enable = true;
              priority = 1;
            };

            actionlint = {
              enable = true;
              priority = 10;
              package = pkgs.callPackage ../../pkgs/actionlint/package.nix { };
            };
            check-added-large-files = {
              enable = true;
              priority = 10;
            };
            check-merge-conflicts = {
              enable = true;
              priority = 10;
            };
            check-symlinks = {
              enable = true;
              priority = 10;
            };
            end-of-file-fixer = {
              enable = true;
              priority = 10;
            };
            shellcheck = {
              enable = true;
              priority = 10;
            };
            trim-trailing-whitespace = {
              enable = true;
              priority = 10;
            };
            zizmor = {
              enable = true;
              priority = 10;
            };
          };
        };
      };

      packages.actionlint = pkgs.callPackage ../../pkgs/actionlint/package.nix { };
    };
}
