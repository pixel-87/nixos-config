{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.neovim;

  defaultTreesitterParsers = [
    "lua"
    "vim"
    "vimdoc"
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
in
{
  options.myModules.neovim = {
    enable = lib.mkEnableOption "Neovim with curated plugins";

    treesitterParsers = lib.mkOption {
      type = with lib.types; listOf str;
      default = defaultTreesitterParsers;
      description = "Treesitter parsers to install (passed to nvim-treesitter.withPlugins).";
    };

    lspPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = defaultLspPackages;
      description = "Language servers to install via Nix (best practice: avoid Mason when packaging with Nix).";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      withNodeJs = true;

      plugins = with pkgs.vimPlugins; [
        # UI / theme
        tokyonight-nvim
        lualine-nvim
        nvim-web-devicons

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

        # Completion & LSP glue
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        LuaSnip
        friendly-snippets
        nvim-lspconfig

        # Treesitter with chosen parsers
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: map (name: p.${name}) cfg.treesitterParsers))
      ];

      extraLuaConfig = ''
        -- Basic options
        vim.g.mapleader = " "
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.cursorline = true
        vim.opt.signcolumn = "yes"
        vim.opt.wrap = true
        vim.opt.linebreak = true
        vim.opt.termguicolors = true
        vim.opt.expandtab = true
        vim.opt.shiftwidth = 2
        vim.opt.softtabstop = 2
        vim.opt.tabstop = 2
        vim.opt.smartindent = true
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.incsearch = true
        vim.opt.scrolloff = 6
        vim.opt.sidescrolloff = 4
        vim.opt.clipboard = "unnamedplus"

        -- Theme
        require("tokyonight").setup({})
        vim.cmd.colorscheme("tokyonight")

        -- Which-key
        require("which-key").setup({})

        -- Telescope
        local telescope = require("telescope")
        telescope.setup({
          defaults = {
            mappings = {
              i = {
                ["<C-k>"] = "move_selection_previous",
                ["<C-j>"] = "move_selection_next",
              },
            },
          },
        })
        pcall(telescope.load_extension, "fzf")

        -- Oil (file explorer)
        require("oil").setup({})

        -- Harpoon
        local harpoon_mark = require("harpoon.mark")
        local harpoon_ui = require("harpoon.ui")
        vim.keymap.set("n", "<leader>ha", harpoon_mark.add_file, { desc = "Harpoon add file" })
        vim.keymap.set("n", "<leader>hh", harpoon_ui.toggle_quick_menu, { desc = "Harpoon list" })
        vim.keymap.set("n", "<leader>h1", function() harpoon_ui.nav_file(1) end, { desc = "Harpoon file 1" })
        vim.keymap.set("n", "<leader>h2", function() harpoon_ui.nav_file(2) end, { desc = "Harpoon file 2" })
        vim.keymap.set("n", "<leader>h3", function() harpoon_ui.nav_file(3) end, { desc = "Harpoon file 3" })
        vim.keymap.set("n", "<leader>h4", function() harpoon_ui.nav_file(4) end, { desc = "Harpoon file 4" })

        -- Keymaps (general)
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
        vim.keymap.set("n", "<leader>e", require("oil").open_float, { desc = "File explorer" })
        vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })

        -- Comment, surround, ai, motions
        require("Comment").setup()
        require("mini.surround").setup()
        require("mini.ai").setup()
        require("leap").create_default_mappings()

        -- Autopairs
        local autopairs = require("nvim-autopairs")
        autopairs.setup({})

        -- Git signs
        require("gitsigns").setup()

        -- Indent guides
        require("ibl").setup()

        -- Todo comments
        require("todo-comments").setup()

        -- Trouble
        require("trouble").setup({})

        -- Notifications / Noice
        vim.notify = require("notify")
        require("noice").setup({
          presets = {
            command_palette = true,
            lsp_doc_border = true,
          },
        })

        -- Lualine
        require("lualine").setup({
          options = { theme = "tokyonight" },
        })

        -- Treesitter
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          indent = { enable = true },
        })

        -- Completion (cmp)
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup({
          snippet = {
            expand = function(args) luasnip.lsp_expand(args.body) end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
            { name = "path" },
          }),
        })

        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = { { name = "buffer" } },
        })

        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
        })

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        -- LSP
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = function(_, bufnr)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "LSP definition")
          map("n", "gr", vim.lsp.buf.references, "LSP references")
          map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
          map("n", "K", vim.lsp.buf.hover, "LSP hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
          map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
          map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
          map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
        end

        local servers = {
          nixd = {},
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
              },
            },
          },
          tsserver = {},
          bashls = {},
          jsonls = {},
          yamlls = {},
          marksman = {},
          pyright = {},
          gopls = {},
          rust_analyzer = {},
        }

        for server, server_opts in pairs(servers) do
          local opts = {
            capabilities = capabilities,
            on_attach = on_attach,
          }
          for k, v in pairs(server_opts) do
            opts[k] = v
          end
          lspconfig[server].setup(opts)
        end
      '';
    };

    home.packages = cfg.lspPackages;
  };
}
