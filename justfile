default:
    @just --list --unsorted

flake := env('FLAKE', justfile_directory())
rebuild := if os() == "macos" { "sudo darwin-rebuild" } else { "nixos-rebuild" }
elevate := if os() == "macos" { "" } else { "--sudo" }

# --- local rebuilds -------------------------------------------------------

[private]
builder host goal *args:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ rebuild }} {{ goal }} {{ elevate }} \
      --flake '{{ flake }}#{{ host }}' {{ args }}

# switch the current machine to the new configuration
switch host: (builder host "switch")

# set the boot configuration without switching (linux only)
[linux]
boot host: (builder host "boot")

# activate without committing the generation (linux only)
[linux]
test host: (builder host "test")

# preview an activation without committing it (linux only)
[linux]
dry host: (builder host "dry-activate")

# --- remote deploy (linux targets) ---------------------------------------

# build locally and deploy to a remote host
[linux]
deploy host *args:
    nixos-rebuild switch --flake '{{ flake }}#{{ host }}' \
      --target-host ssh-ng://{{ host }} --use-substitutes {{ args }}

# build on the remote host and deploy
[linux]
deploy-remote host *args:
    nixos-rebuild switch --flake '{{ flake }}#{{ host }}' \
      --build-host 'root@{{ host }}' --target-host 'root@{{ host }}' \
      --no-reexec --use-substitutes {{ args }}

# --- verification ---------------------------------------------------------

# evaluate the flake without building anything
check *args:
    nix flake check --no-build \
      --option allow-import-from-derivation false \
      '{{ flake }}' {{ args }}

# drop into a repl on a nixos host's evaluated config
repl host:
    nix repl '{{ flake }}#nixosConfigurations.{{ host }}'

# drop into a repl on a darwin host's evaluated config
repl-mac host:
    nix repl '{{ flake }}#darwinConfigurations.{{ host }}'

# build a host and show what would change
diff host:
    nix build '{{ flake }}#nixosConfigurations.{{ host }}.config.system.build.toplevel' \
      -o 'result-{{ host }}'
    nvd diff /run/current-system 'result-{{ host }}'

# --- maintenance ---------------------------------------------------------

# update the given flake inputs, or all of them
update *inputs:
    nix flake update {{ inputs }} --commit-lock-file \
      --commit-lockfile-summary "flake.lock: update {{ if inputs == "" { "all inputs" } else { replace(inputs, " ", ", ") } }}" \
      --flake '{{ flake }}'

# format the tree with the flake formatter
fmt *args:
    nix fmt '{{ flake }}' {{ args }}

# garbage-collect old store paths
clean:
    nix-collect-garbage --delete-older-than 30d
