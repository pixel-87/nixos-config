{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.myModules.neovim;

  defaultTreesitterParsers = [
    "lua"
    "vim"
    "vimdoc"
    "regex"
    "nix"
    "bash"
    "json"
    "yaml"
    "toml"
    "markdown"
    "markdown_inline"
    "typescript"
    "javascript"
    "tsx"
    "css"
    "html"
    "python"
    "go"
    "rust"
    "dockerfile"
    "sql"
  ];

  defaultLspPackages = with pkgs; [
    nixd
    lua-language-server
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    pyright
    gopls
    rust-analyzer
    marksman
  ];

  plugin-99 = pkgs.vimUtils.buildVimPlugin {
    pname = "99";
    version = "master";
    src = inputs.plugin-99;
    doCheck = false;
  };
in
{
  options.myModules.neovim = {
    enable = lib.mkEnableOption "Neovim with curated plugins (via nixvim)";

    treesitterParsers = lib.mkOption {
      type = with lib.types; listOf str;
      default = defaultTreesitterParsers;
      description = "Treesitter parsers to install (passed to nvim-treesitter.withPlugins).";
    };

    lspPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = defaultLspPackages;
      description = "Language servers to install via Nix; passed to nixvim.extraPackages.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      extraPackages = cfg.lspPackages;

      opts = {
        number = true;
        relativenumber = true;
        cursorline = true;
        signcolumn = "yes";
        wrap = true;
        linebreak = true;
        termguicolors = true;
        expandtab = true;
        shiftwidth = 2;
        softtabstop = 2;
        tabstop = 2;
        smartindent = true;
        ignorecase = true;
        smartcase = true;
        incsearch = true;
        scrolloff = 6;
        sidescrolloff = 4;
        clipboard = "unnamedplus";
      };

      globals.mapleader = " ";

      plugins.lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                diagnostics = {
                  globals = [ "vim" ];
                };
                workspace = {
                  checkThirdParty = false;
                };
              };
            };
          };
          ts_ls.enable = true;
          bashls.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          marksman.enable = true;
          pyright.enable = true;
          gopls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      plugins.markdown-preview = {
        enable = true;
        settings.auto_start = 0;
      };

      plugins.render-markdown = {
        enable = true;
        settings = {
          latex.enabled = false;
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        # UI / theme
        catppuccin-nvim
        lualine-nvim
        nvim-web-devicons

        # AI
        plugin-99

        # Core + navigation
        plenary-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        harpoon
        which-key-nvim
        oil-nvim

        # Editing ergonomics
        comment-nvim
        nvim-autopairs
        mini-nvim
        leap-nvim

        # Git
        gitsigns-nvim

        # Syntax / visuals
        indent-blankline-nvim
        todo-comments-nvim
        trouble-nvim
        noice-nvim
        nvim-notify
        nui-nvim
        precognition-nvim

        # Completion & LSP glue
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        luasnip
        friendly-snippets
        nvim-lspconfig

        # Terminals
        toggleterm-nvim

        # Treesitter with chosen parsers
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: map (name: p.${name}) cfg.treesitterParsers))
      ];

      extraConfigLua = builtins.readFile ./neovim/config.lua;
    };
  };
}
