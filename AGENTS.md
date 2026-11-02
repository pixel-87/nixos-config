# NixOS Configuration Blueprint

## System Overview

Personal, fully declarative NixOS configuration built with a
[flake-parts](https://github.com/hercules-ci/flake-parts) flake targeting
`x86_64-linux` only. It combines NixOS, Home Manager, Stylix, nixvim, and
Hyprland into three system configurations:

| Flake attribute | Host directory | Role |
| --- | --- | --- |
| `laptop` | `hosts/laptop` | Graphical Hyprland laptop; Lanzaboote Secure Boot; tuned/PPD; Tailscale. |
| `lithium` | `hosts/lithium` | Upstream Kubernetes control plane + worker (NixOS `services.kubernetes`, **not k3s**); Cilium CNI; Tailscale. |
| `tungsten` | `hosts/tungsten` | Graphical Hyprland desktop; systemd-boot; Bluetooth. |

All three include `hosts/common` and the `pixel` Home Manager user. Each host's
Home Manager imports `hosts/common/home.nix` plus its own `home.nix`; the common
home module imports all of `modules/home` and the `nix-index-database` module.
`specialArgs` and `extraSpecialArgs` pass the flake `inputs` into every module.

`nixpkgs` is pinned to the fork `pixel-87/nixpkgs/certmgr-unstable`. The comment
in `flake.nix` says this carries a certmgr SAN fix until
[NixOS/nixpkgs#434442](https://github.com/NixOS/nixpkgs/issues/434442) lands. Do
not switch back to upstream `nixpkgs` without verifying that fix.

## Subdirectories & System Boundaries

- `flake.nix`: Flake inputs and `nixosConfigurations` wiring; declares the
  `nixfmt-tree` formatter and a minimal devShell. This is where a new host is
  registered.
- `hosts/`: Per-machine configuration.
  - `hosts/common/`: Shared NixOS settings (`default.nix`) and shared Home
    Manager settings (`home.nix`). Every host imports both layers.
  - `hosts/<host>/default.nix`: Host hardware, bootloader, kernel, services, and
    module imports.
  - `hosts/<host>/home.nix`: Host-specific Home Manager packages, desktop
    configuration, and `myModules.*` toggles.
  - `hosts/<host>/hardware-configuration.nix`: Generated hardware scan. Do not
    hand-edit for cosmetic reasons; regenerate when hardware changes.
  - `hosts/hostnames.md`: Human notes mapping host names to roles. Informational
    only; it does not configure anything.
- `modules/nixos/`: Reusable NixOS modules. `default.nix` currently imports
  nothing; its commented imports are legacy k3s entries. Active modules are
  imported directly by hosts:
  - `bluetooth.nix`, `stylix.nix`, `tailscale.nix`.
  - `roles/k8s/{common,control-plane,worker}.nix`: Active upstream-Kubernetes
    node roles used by `lithium` (`services.kubernetes`). The `k8s` in the path
    is accurate; these are not k3s modules.
  - `services/k3s/cilium.nix`: Active despite living under the legacy `k3s`
    directory name; `lithium` imports it directly. It disables flannel and
    configures the containerd CNI paths for Cilium.
  - `services/k3s/{cert-manager,longhorn,flux}.nix` are legacy k3s modules and
    are **not imported anywhere**. `cert-manager.nix` and `longhorn.nix` are
    pulled in only by the unused `roles/k8s/k3s-server.nix`. `flux.nix` also
    references `gotk-components.yaml` and `gotk-sync.yaml`, which now live only
    in `k8s-backup/flux-system`.
  - `roles/k8s/k3s-server.nix` is a legacy k3s role and is not imported; it is
    referenced only by a comment in `modules/nixos/default.nix`.
- `modules/home/`: Reusable Home Manager modules. `default.nix` imports the
  baseline CLI/editor/shell set (`cli`, `neovim`, `shell`, `git`, `vim`,
  `pentesting`, `fastfetch`, `starship`, `opencode`, `tmux`). GUI and
  host-specific modules (`hyprland/`, `noctalia`, `firefox`, `zen-browser`,
  `font`, `wallpaper`, `profiles/`) are imported by individual hosts, not by
  the baseline.
- `pkgs/`: Reserved for custom packages. Currently empty.
- `k8s/`: Active Flux-managed cluster state. `k8s/kustomization.yaml` lists the
  Flux system, Envoy Gateway, and the Minecraft app. `k8s/flux-system/flux.yaml`
  is a `FluxInstance` that syncs `https://github.com/pixel-87/nixos-config` at
  `refs/heads/main`, path `./k8s`. `k8s-backup/` is deliberately outside that
  path and is never applied.
- `k8s-backup/`: Frozen archive of the decommissioned k3s-era cluster state:
  the old Flux `gotk-*` bootstrap, Longhorn, MetalLB, monitoring, Pi-hole, and
  `ed-thomas-dev` app manifests. It is not reconciled by Flux and should not be
  wired back in.
- `deploy/`: Out-of-band cluster bootstrap, deliberately outside `k8s/` so Flux
  cannot delete it. `deploy/cilium` is Helm/helmfile-managed CNI configuration
  with its own operational README.
- `assets/`: Images and the `assets/wallpapers` git submodule.
- `.github/workflows/`: CI for flake evaluation, lock validation, formatting,
  and scheduled input updates.

## Repository Interface & Invariants

### Entry points

- Flake outputs: `nixosConfigurations.{laptop,lithium,tungsten}`,
  `devShells.x86_64-linux.default`, and `formatter.x86_64-linux`.
- Home Manager modules expose options under `myModules.<name>` using
  `lib.mkEnableOption` and `lib.mkOption`, e.g. `myModules.opencode`,
  `myModules.hyprland`, `myModules.git`.
- Kubernetes entry point is `k8s/kustomization.yaml`; cluster bootstrap is
  `deploy/cilium/helmfile.yaml`.

### Invariants

- `hosts/common/default.nix` sets `system.stateVersion = lib.mkDefault "25.05"`
  and each host sets `home.stateVersion = "25.05"`. Never change a
  `stateVersion` as part of an unrelated change.
- `hosts/common/default.nix` pins `upower` to `1.91.3` via an overlay because
  nixpkgs `1.91.4` produces masked systemd units and aborts
  `switch-to-configuration`. Keep the pin until nixpkgs ships a fixed version.
- The flake attribute name and the machine hostname are not the same: for
  example, `hosts/laptop/default.nix` sets
  `networking.hostName = "nixos"`. Use the flake attribute (`.#laptop`) for
  builds and rebuilds.
- `modules/home/default.nix` is the shared baseline. Add a module there only if
  every host should get it; otherwise import it from the specific host.
- On GUI hosts (`laptop`, `tungsten`),
  `stylix.targets.hyprland.hyprpaper.enable = false` is required because
  Noctalia owns the wallpaper. Do not enable both wallpaper daemons.
- `lithium` is the only host wired into Kubernetes. It runs **upstream
  Kubernetes through NixOS `services.kubernetes`**, not k3s. It uses
  `roles/k8s/common.nix`, `control-plane.nix`, and `worker.nix`, with node IP
  `192.168.0.45`, master address `master.ed-thomas.local`, and API server
  `https://master.ed-thomas.local:6443`.
- k3s is gone from the active configuration. Do not reintroduce
  `services.k3s`, and do not treat `k8s-backup/` or the legacy
  `modules/nixos/services/k3s/*` modules as current.
- Cilium is the CNI. Flannel is explicitly disabled in
  `roles/k8s/common.nix` and `services/k3s/cilium.nix`; the remaining flannel
  settings in `hosts/lithium/default.nix` are inert legacy configuration.
- Flux only reconciles `k8s/`, never `k8s-backup/`. Keep CNI/bootstrap material
  in `deploy/`.
- The `.sops.yaml` creation rule matches `k8s/*.secret.yaml` and encrypts only
  `data` and `stringData`, for the `pixel_laptop` SSH and `flux_cluster` age
  recipients. Never commit plaintext secrets or edit encrypted values by hand.
  Note that `k8s-backup/` is outside this rule and contains a legacy plaintext
  credential; do not copy that pattern into the active tree.
- `assets/wallpapers` is a git submodule. Do not replace it with vendored
  copies.
- Nix files must be formatted with the flake formatter (`nixfmt-tree`); CI
  rejects unformatted changes.

## Global Side Effects

- `nixos-rebuild switch` activates a new system generation, updates the
  bootloader, and on `laptop` involves Lanzaboote Secure Boot signing through
  `/var/lib/sbctl`.
- `nix build ... -o result-*` and `nixos-rebuild` create `result*` symlinks;
  `result` is gitignored.
- Pushing to `main` is a deployment action: the `FluxInstance` watches
  `refs/heads/main` and applies everything under `k8s/` (and nothing under
  `k8s-backup/`) to the cluster.
- `.github/workflows/update.yml` runs daily at `03:03 UTC`, updates
  `flake.lock`, opens a PR, runs checks, builds `laptop` and `lithium`, and
  auto-merges if everything passes. `tungsten` is not built by that workflow.
- `deploy/cilium` changes affect cluster networking and are applied manually
  with Helm/helmfile on the host, not through Flux.

## System Verification

There is no unit-test suite. Verification is flake evaluation, formatting, and
building the system closures:

```bash
# Evaluate all flake outputs and configurations
nix flake check --option allow-import-from-derivation false

# Check formatting (CI-equivalent)
nix fmt -- --fail-on-change .

# Build a host closure (repeat for lithium and tungsten)
nix build .#nixosConfigurations.laptop.config.system.build.toplevel \
  --option allow-import-from-derivation false

# Apply on the target machine
sudo nixos-rebuild switch --flake .#<host>
```

CI builds only `laptop` and `lithium`, so build `tungsten` locally when you
touch shared modules or its host directory.

## Agent Working Rules

- Read this file before changing anything under `hosts/`, `modules/`, `k8s/`,
  or `deploy/`.
- Prefer editing a shared module over duplicating configuration in multiple
  hosts. `hosts/laptop` and `hosts/tungsten` are near-identical and are the
  first place to look for deduplication.
- Add new Home Manager functionality as a `myModules.<name>` module with an
  explicit `enable` option.
- Do not change `stateVersion`, the `upower` pin, or the `nixpkgs` fork without
  a specific, stated reason.
- Run `nix fmt` after editing Nix, and run at least `nix flake check` plus a
  build of every affected host before finishing.
- Do not commit, push, or run `nixos-rebuild switch` unless the user asks.
- Do not place cluster bootstrap or CNI configuration under `k8s/`.
- Treat `k8s-backup/` and the legacy `k3s` modules as read-only history. Do not
  copy from them into the active configuration without confirming the
  upstream-Kubernetes equivalent.
