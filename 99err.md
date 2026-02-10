pixel@nixos …/nixos-config on  main (   ) 
╰─ nixos-rebuild switch --flake .#laptop --sudo
warning: Git tree '/home/pixel/nixos-config' is dirty
warning: updating lock file "/home/pixel/nixos-config/flake.lock":
• Added input 'plugin-99':
    'github:ThePrimeagen/99/d9dfb2336364fa0985137b56d8b13dc806fea7a7?narHash=sha256-IclgkGmgRPQp%2B183ln2IzrPhje2cq/4BtRszUh76tv8%3D' (2026-02-08)
building the system configuration...
warning: Git tree '/home/pixel/nixos-config' is dirty
evaluation warning: 'system' has been renamed to/replaced by 'stdenv.hostPlatform.system'
error: Cannot build '/nix/store/xl4j5ajnqbb1s4d2zp1b1jc16ba5y233-vimplugin-99-master.drv'.
       Reason: builder failed with exit code 1.
       Output paths:
         /nix/store/2j8ahclq3saab5vfncvwp1wdnf5fg1yx-vimplugin-99-master
       Last 25 log lines:
       >   - 99.extensions.agents.init
       >   - 99.extensions.agents.helpers
       >   - 99.extensions.init
       >   - 99.extensions.cmp
       >   - 99.language.ruby
       >   - 99.language.cpp
       >   - 99.language.lua
       >   - 99.language.init
       >   - 99.language.java
       >   - 99.language.typescript
       >   - 99.language.elixir
       >   - 99.language.go
       >   - 99.logger.logger
       >   - 99.logger.level
       >   - 99.editor.init
       >   - 99.editor.treesitter
       >   - 99.prompt-settings
       >   - 99.request-context
       > All lua modules were checked.
       >
       > Require check failed for the following modules:
       >   - 99.editor.lsp
       >
       > Checkout https://nixos.org/manual/nixpkgs/unstable/#testing-neovim-plugins-neovim-require-check
       > ======================================================
       For full logs, run:
         nix log /nix/store/xl4j5ajnqbb1s4d2zp1b1jc16ba5y233-vimplugin-99-master.drv
error: Cannot build '/nix/store/9qwkhk2f91vxafgffc65gcyhy4xj543b-neovim-0.11.6.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/6zmzx1a87cyi3nw6rh547jwgmw2p8p14-neovim-0.11.6
error: Cannot build '/nix/store/fiwqskb62lwm25pr1nb2p65php02syvf-nixvim.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/3nx2s20i3ywh56wg24n0y04mrddbdqkj-nixvim
error: Cannot build '/nix/store/dp8vwaik79k1q84mma5i4vdam4nm0bqj-home-manager-path.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/6n1jm3xxj6g0b40102dbvri7jrczsafg-home-manager-path
error: Cannot build '/nix/store/mljqsfyc4klf788kbx4k0h6bx70ijinb-man-paths.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/0f6s8nd16hnlrfa8cv7h4nji3akak3r1-man-paths
error: Cannot build '/nix/store/a64balp89i9g95gfraw7svhpmif2ijwj-nixvim-fish-completions.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/id7d26s41l83695bq30p270v6qvbs1kc-nixvim-fish-completions
error: Cannot build '/nix/store/cm4a3asrws41qxdk0nghqsffxx3pdc8z-home-manager-generation.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/nmppq5vc5lzk71kihfabnydkh9xspxxg-home-manager-generation
error: Cannot build '/nix/store/s6mq2l6cki4d00lw6hkc5b992mhqwvjp-user-environment.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/yimg89hy06vl957w6gqmjr4qiz9sh51l-user-environment
error: Cannot build '/nix/store/n9m7py6snhf6lv2y90wb3104hj535hv1-etc.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/a7hylrnzfjv1vikskppfgmz3d873kqm0-etc
error: Cannot build '/nix/store/b9s65h23y183448xw53aylnxx80g3wpv-nixos-system-nixos-26.05.20260204.aa290c9.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/vfk79zxg0pw560qhbxvkxxzqjanrm11a-nixos-system-nixos-26.05.20260204.aa290c9
Command 'nix --extra-experimental-features 'nix-command flakes' build --print-out-paths '.#nixosConfigurations."laptop".config.system.build.toplevel' --no-link' returned non-zero exit status 1.

╭╴pixel@nixos …/nixos-config on  main (   ) 
╰─ 
