# NixOS Config

Personal flake for my machines: NixOS, one nix-darwin host, and Home Manager
everywhere. Built with flake-parts; `flake.nix` is inputs only, all wiring
lives in `modules/flake/`.

## Hosts

| Flake attr | Machine | Notes |
| --- | --- | --- |
| `laptop` | laptop | Hyprland GUI; Lanzaboote secure boot. Hostname is `nixos`, not `laptop`. |
| `tungsten` | desktop | Hyprland GUI; systemd-boot. |
| `lithium` | old desktop server | The only Kubernetes node (upstream `services.kubernetes`, **not k3s**). |
| `silicon` | macOS, aarch64 | nix-darwin. |

Hosts are registered in the `hosts` attrset in `modules/flake/hosts.nix`
(`class`, `arch`, `username`); a host is `hosts/<name>/default.nix` plus
`hosts/<name>/home.nix` and nothing else. `hosts/hostnames.md` holds loose
human notes (including planned machines).

## Layout

- `modules/flake/` — flake wiring: host construction, checks, formatter,
  pre-commit hooks, devShell.
- `modules/nixos/common.nix`, `modules/darwin/common.nix`,
  `modules/home/common.nix` — what every machine of that class gets.
- `modules/home/` — Home Manager modules, exposed as `myModules.<name>`
  options with `enable` flags, plus `profiles/` for opt-in bundles
  (e.g. `profiles/gui.nix` = everything a Hyprland desktop wants).
- `modules/nixos/profiles/` — same idea for NixOS.
- `hosts/<name>/` — deltas only: hardware, boot, host-specific packages.
- `pkgs/` — custom packages.
- `k8s/` — Flux-managed cluster state; `k8s-backup/` is a frozen archive of
  the old k3s cluster and is never applied; `deploy/` is out-of-band cluster
  bootstrap that Flux must not touch.
- `assets/` — wallpapers submodule; don't vendor it.

## Conventions

- New Home Manager functionality = a `myModules.<name>` module with an
  explicit `enable` option. Put it in the shared baseline only if every
  host should have it; otherwise import it from a profile or a host.
- Common modules are push-only: if a module starts reading host flags it
  no longer belongs in `common.nix`.
- Anything shared by laptop and tungsten usually belongs in the GUI
  profiles, not in both host files.
- **Flakes only see tracked files.** `git add` any new file before
  evaluating, building, or rebuilding — untracked files are silently
  invisible, which has caused confusing "option does not exist" errors.

## Invariants

- `system.stateVersion` is set once in the per-class common modules. Never
  change it.
- lithium: upstream Kubernetes via `modules/nixos/roles/k8s/*`, Cilium CNI,
  flannel disabled. The `services/k3s/` module dir and `k8s-backup/` are
  history; don't copy from them into active config.
- Secrets: `.sops.yaml` covers `k8s/*.secret.yaml` only. Never commit
  plaintext secrets.
- nixpkgs is the channel tarball. Historically it was pinned to a fork
  carrying the certmgr SAN fix (NixOS/nixpkgs#434442); if you touch
  certmgr, check that issue is actually resolved in current unstable.

## Verification

Favour evaluation over building: most mistakes (missing options, broken
imports, wrong types) are caught by evaluation alone, which is fast and
requires nothing from the store. Build only when evaluation can't tell you
what you need.

```
nix fmt                                            # treefmt: nixfmt, deadnix, statix, shfmt
nix develop                                        # prek-managed pre-commit hooks
nix flake check --no-build --option allow-import-from-derivation false
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath
nix build <one specific attr>                      # only when a real build is needed
```

- Always pass `--no-build` to `nix flake check`: the `checks` output builds
  every NixOS host's toplevel, which is a full system build. Darwin hosts
  are not wired into checks yet.
- The agent may build individual derivations (a package, a single module
  test) when needed, but never a whole system closure.
- Full rebuilds are the user's job: never run `nixos-rebuild` or build a
  host toplevel unless explicitly asked. Report what to rebuild instead.

CI (`.github/workflows/ci.yaml`) evaluates the flake, then builds the
checks matrix per system; `update.yaml` opens a daily lockfile PR and
auto-merges when CI passes.

## Side effects

- `nixos-rebuild switch` activates a new generation; on laptop that also
  involves Lanzaboote signing via `/var/lib/sbctl`.
- Pushing to `main` is a deployment action: the FluxInstance watches
  `refs/heads/main` and applies everything under `k8s/` to the cluster.

## Working rules

- Prefer editing a shared module over duplicating configuration in hosts;
  `hosts/laptop` and `hosts/tungsten` are the first place to check for
  deduplication.
- Run `nix fmt` after editing Nix, and evaluate affected hosts
  (`nix flake check --no-build`, or `nix eval` on the specific
  configuration) before finishing.
- Don't commit, push, or run `nixos-rebuild switch` unless asked.
- Treat `k8s-backup/` and the legacy k3s modules as read-only.
