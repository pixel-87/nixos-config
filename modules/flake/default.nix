{
  imports = [ ./hosts.nix ];

  perSystem = { pkgs, ... }:
  {
    formatter = pkgs.nixfmt-tree;

    devShells.default = pkgs.mkShell {
      packages = [pkgs.git pkgs.nvim];
    };
  };
}
