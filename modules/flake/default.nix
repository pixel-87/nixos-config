{ inputs, ... }:
{
  imports = [
    ./hosts.nix
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    { pkgs, config, ... }:
    {
      formatter = pkgs.nixfmt-tree;

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
            nixfmt.enable = true;
            deadnix.enable = true;
            #statix.enable = true;
            actionlint.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            check-merge-conflicts.enable = true;
            check-added-large-files.enable = true;
            check-symlinks.enable = true;
            end-of-file-fixer.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };
      };
    };
}
