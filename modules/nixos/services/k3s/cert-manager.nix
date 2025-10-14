{ config, pkgs, lib, ... }:

let
  acmeEmail = "edwardoliverthomas@gmail.com";
in
{
  # Deploy cert-manager first
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

  # Job that waits for cert-manager, then creates ClusterIssuers
  environment.etc."rancher/k3s/server/manifests/02-cert-manager-setup.yaml".text = ''
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: cert-manager-setup
      namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: cert-manager-setup
    rules:
    - apiGroups: ["cert-manager.io"]
      resources: ["clusterissuers"]
      verbs: ["create", "get", "list"]
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["list"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cert-manager-setup
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cert-manager-setup
    subjects:
    - kind: ServiceAccount
      name: cert-manager-setup
      namespace: kube-system
    ---
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: cert-manager-setup
      namespace: kube-system
    spec:
      ttlSecondsAfterFinished: 60
      template:
        spec:
          serviceAccountName: cert-manager-setup
          restartPolicy: OnFailure
          containers:
          - name: setup

