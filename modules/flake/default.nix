{ inputs, lib, ... }:
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
            nixd
          ]
          ++ config.pre-commit.settings.enabledPackages;

        shellHook = config.pre-commit.shellHook;
      };

      pre-commit = {
        settings = {
          package = pkgs.prek;

          hooks =
            let
              commonHooks =
                lib.genAttrs
                  [
                    "check-added-large-files"
                    "check-merge-conflicts"
                    "check-symlinks"
                    "end-of-file-fixer"
                    "shellcheck"
                    "trim-trailing-whitespace"
                    "zizmor"
                  ]
                  (_name: {
                    enable = true;
                    priority = 10;
                  });
            in
            commonHooks
            // {
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
            };
        };
      };

      packages.actionlint = pkgs.callPackage ../../pkgs/actionlint/package.nix { };
    };
}
