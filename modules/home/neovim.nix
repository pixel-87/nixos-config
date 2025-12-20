{ config, lib, pkgs, ... }:

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
                diagnostics = { globals = [ "vim" ]; };
                workspace = { checkThirdParty = false; };
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

      plugins.render-markdown.enable = true;

      extraPlugins = with pkgs.vimPlugins; [
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

        # Treesitter with chosen parsers
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: map (name: p.${name}) cfg.treesitterParsers))
      ];

      extraConfigLua = ''
        -- Treat .mdx files as markdown (MDX is Markdown + JSX)
        vim.filetype.add({
          extension = {
            mdx = "markdown",
          },
        })

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
        vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
        vim.keymap.set("n", "<leader>tp", function() require("precognition").toggle() end, { desc = "Toggle Precognition" })

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

        -- Precognition
        require("precognition").setup({
          startVisible = false,
        })

        -- Trouble
        require("trouble").setup({})

        -- Notifications / Noice
        vim.notify = require("notify")
        require("noice").setup({
          presets = {
            command_palette = true,
            lsp_doc_border = true,
          },
          lsp = {
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
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

        -- LSP keymaps on attach (works with nixvim's lsp module)
        local lsp_group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
          group = lsp_group,
          callback = function(ev)
            local map = function(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
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
          end,
        })
      '';
    };
  };
}
