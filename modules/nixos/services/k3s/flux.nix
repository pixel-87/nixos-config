{ config, pkgs, ... }:

let
  fluxSystemPath = ../../../../k8s/lithium/flux-system;
in
{
  # 1. Apply the Flux CRDs and controllers
  environment.etc."rancher/k3s/server/manifests/00-flux-components.yaml".source =
    "${fluxSystemPath}/gotk-components.yaml";

  # 2. Apply the Flux sync configuration to bootstrap the cluster
  environment.etc."rancher/k3s/server/manifests/01-flux-sync-v2.yaml".source =
    "${fluxSystemPath}/gotk-sync.yaml";
}
