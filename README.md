# NixOS Configuration

## Modules

To use these modules, import `modules/home` in your Home Manager configuration and enable the desired options.

```nix
imports = [ ./modules/home ];
myModules.cli.enable = true;
myModules.neovim.enable = true;
```

### CLI Tools (`modules/home/cli.nix`)
A collection of modern Linux tools to enhance the shell experience.

| Tool | Description | Alias / Usage |
|------|-------------|---------------|
| **eza** | Modern `ls` replacement with git integration. | `ls`, `l`, `la`, `ll`, `lla` (aliased) |
| **bat** | Cat clone with syntax highlighting. | `cat` (aliased) |
| **comma** | Run software without installing it. | `, <command>` (e.g., `, cowsay hi`) |
| **nix-tree** | Interactively browse dependency graphs of Nix derivations. | `nix-tree` |
| **nix-index** | Files database for Nix; powers `command-not-found`. | `nix-locate` |
| **nvd** | Nix Version Diff; compare package versions between generations. | `nvd diff /run/current-system result` |
| **zoxide** | Smarter `cd` command that learns your habits. | `cd` (aliased) or `z` |
| **fd** | Simple, fast and user-friendly alternative to `find`. | `fd` |
| **fzf** | General-purpose command-line fuzzy finder. | `Ctrl+R` (history), `Ctrl+T` (files) |
| **ripgrep** | Line-oriented search tool (grep alternative). | `rg <pattern>` |
| **dust** | More intuitive version of `du` (disk usage). | `du` (aliased) |
| **procs** | Modern replacement for `ps`. | `ps` (aliased) |
| **lazygit** | Simple terminal UI for git commands. | `lazygit` |
| **tldr** | Simplified and community-driven man pages. | `tldr <command>` |
| **direnv** | Unclutter your .profile; loads env vars per directory. | Auto-loads `.envrc` |
| **nix-direnv** | Fast, persistent use_nix implementation for direnv. | Used within `.envrc` |

### Neovim (`modules/home/neovim.nix`)
A fully configured Neovim setup using `nixvim`.
- **Plugins**: Telescope, Harpoon, Oil, Treesitter, LSP (nixd, lua_ls, etc.), and more.
- **Theme**: Tokyo Night.

### Shell (`modules/home/shell.nix`)
Enhanced Zsh configuration with:
- **starship** prompt for customizable shell appearance
- **Safety aliases**: `rm -i`, `mv -i`, `cp -i`
- **NixOS helpers**: `switch`, `build`, per-host variants
- **History management**: Shared history, duplicate filtering

### Git (`modules/home/git.nix`)
Git configuration with sensible defaults:
- Default branch: `main`
- Rebase on pull
- Color output with moved code highlighting
- Configurable per-host via `myModules.git.userEmail`

### Vim (`modules/home/vim.nix`)
Traditional Vi/Vim editor with modern defaults (indentation, line numbers, clipboard).
