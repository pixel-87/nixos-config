# Cilium

Cilium is the CNI and is deliberately **not** managed by Flux. Flux runs as
pods on the network Cilium provides, so it cannot be the thing that repairs it.

This directory lives outside `k8s/` on purpose: Flux only reconciles `k8s/`,
and a directory move or refactor there must never be able to delete the CNI
release.

## Install / upgrade

```bash
helmfile -f deploy/cilium/helmfile.yaml apply
```

or directly:

```bash
helm upgrade --install cilium oci://quay.io/cilium/charts/cilium \
  --version <version> \
  -n kube-system \
  -f deploy/cilium/cilium-values.yaml
```

Change the version in both files in the same commit. Values are the single
source; do not inline a second copy elsewhere.

## Status

```bash
kubectl -n kube-system get pods -l k8s-app=cilium
kubectl -n kube-system exec ds/cilium -- cilium-dbg status --brief
helm -n kube-system history cilium
```

## Rollback

```bash
helm -n kube-system rollback cilium <last-good-revision>
```

`helm rollback` restores the release manifest only. It does not restore CRDs,
the CNI configuration file, BPF state, or routes.

## Emergency

Run these on the host over Tailscale SSH, not through Flux:

```bash
curl -sk https://127.0.0.1:6443/healthz   # API server is a host systemd service
kubectl get nodes
kubectl -n kube-system get pods -l k8s-app=cilium
```

If the API server is healthy but pods cannot resolve or reach each other, the
CNI is the problem and `helm` on the host is the recovery path.
