{
  config,
  pkgs,
  lib,
  ...
}:

let
  acmeEmail = "edwardoliverthomas@gmail.com";
in
{
  # Deploy cert-manager
  environment.etc."rancher/k3s/server/manifests/01-cert-manager.yaml".text = ''
    apiVersion: v1
    kind: Namespace
    metadata:
      name: cert-manager
    ---
    apiVersion: helm.cattle.io/v1
    kind: HelmChart
    metadata:
      name: cert-manager
      namespace: kube-system
    spec:
      chart: cert-manager
      repo: https://charts.jetstack.io
      targetNamespace: cert-manager
      version: v1.13.3
      valuesContent: |
        installCRDs: true
  '';

  # ClusterIssuers - these will be applied after cert-manager is ready
  # Note: These may fail on first boot until cert-manager CRDs are installed
  environment.etc."rancher/k3s/server/manifests/02-letsencrypt-issuers.yaml".text = ''
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-staging
    spec:
      acme:
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        email: ${acmeEmail}
        privateKeySecretRef:
          name: letsencrypt-staging-key
        solvers:
        - http01:
            ingress:
              class: traefik
    ---
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: ${acmeEmail}
        privateKeySecretRef:
          name: letsencrypt-prod-key
        solvers:
        - http01:
            ingress:
              class: traefik
  '';
}
