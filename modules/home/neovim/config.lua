-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Persistent undo (save undo history across sessions)
vim.opt.undofile = true

-- Treat .mdx files as markdown (MDX is Markdown + JSX)
vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

-- Autosave on buffer change and focus loss
vim.api.nvim_create_autocmd({"BufLeave", "FocusLost"}, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local bt = vim.bo[bufnr].buftype
    local ft = vim.bo[bufnr].filetype
    if bt ~= "" then
      return
    end
    if ft == "oil" then
      return
    end
    if not vim.bo[bufnr].modifiable then
      return
    end
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
      return
    end
    if vim.bo[bufnr].modified then
      vim.cmd.write()
    end
  end,
})

-- Python: Force 2-space indentation (override default 4-space)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
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
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})
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
vim.keymap.set("n", "<leader>e", require("oil").open_float, { desc = "File explorer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
vim.keymap.set("n", "<leader>tp", function() require("precognition").toggle() end, { desc = "Toggle Precognition" })

vim.keymap.set(
  "n",
  "<leader>ie",
  "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- Comment, surround, ai, motions
require("Comment").setup()
require("mini.surround").setup()
require("mini.ai").setup()
require("leap").setup({})

-- Autopairs
local autopairs = require("nvim-autopairs")
autopairs.setup({})

-- Git signs
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
    end, { expr = true, desc = "Next git hunk" })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "Prev git hunk" })

    -- Actions
    map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview git hunk" })
    map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset git hunk" })
    map('v', '<leader>gr', function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { desc = "Reset git hunk (visual)" })
    map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset git buffer" })
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, { desc = "Git blame line" })
    map('n', '<leader>gd', gs.diffthis, { desc = "Git diff this" })
    map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = "Git diff this ~" })
  end
})

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

vim.notify = require("notify")
require("noice").setup({
    command_palette = true,
    lsp_doc_border = true,
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
})

-- Lualine
require("lualine").setup({
  options = { theme = "tokyonight" },
})

-- Manually start treesitter for all buffers (workaround for recent nvim-treesitter issues)
vim.api.nvim_create_autocmd({"FileType", "BufRead"}, {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Render Markdown setup is handled by nixvim module

-- 99 (AI Agent by ThePrimeagen)
-- Requires 'opencode' to be installed and setup
local _99 = require("99")
local cwd = vim.uv.cwd()
local basename = vim.fs.basename(cwd)
_99.setup({
  logger = {
    level = _99.DEBUG,
    path = "/tmp/" .. basename .. ".99.debug",
    print_on_error = true,
  },
  completion = {
    -- custom_rules = { "scratch/custom_rules/" }, -- Example
    source = "cmp",
  },
  md_files = {
    "AGENT.md",
  },
})

vim.keymap.set("n", "<leader>9f", function() _99.fill_in_function() end, { desc = "99: Fill function" })
vim.keymap.set("v", "<leader>9v", function() _99.visual() end, { desc = "99: Visual" })
vim.keymap.set("v", "<leader>9s", function() _99.stop_all_requests() end, { desc = "99: Stop all" })
vim.keymap.set("n", "<leader>9fd", function() _99.fill_in_function() end, { desc = "99: Fill debug" })



-- ToggleTerm (terminal runner)
  require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    shade_terminals = true,
    shading_factor = 2,
    direction = "horizontal",
  })
  vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
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
    map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
  end,
})
