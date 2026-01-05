{ ... }:

{
  imports = [
    ./roles/k3s-server.nix
    ./services/k3s/cert-manager.nix
    ./services/k3s/flux.nix
    ./services/k3s/longhorn.nix
  ];
}
