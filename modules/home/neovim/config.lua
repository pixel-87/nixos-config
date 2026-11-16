-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Persistent undo (save undo history across sessions)
vim.opt.undofile = true

-- Filetype detection for formats Neovim doesn't know out of the box:
-- MDX (Markdown + JSX), OpenTofu, Helm charts, Docker Compose and Ansible.
vim.filetype.add({
  extension = {
    mdx = "markdown",
    tofu = "opentofu",
  },
  pattern = {
    -- Helm: chart templates and values files
    [".*/templates/.*%.ya?ml"] = "helm",
    [".*/values%.ya?ml"] = "yaml.helm-values",
    -- Docker Compose
    ["compose%.ya?ml"] = "yaml.docker-compose",
    ["compose%.override%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose%.override%.ya?ml"] = "yaml.docker-compose",
    -- Ansible
    [".*/ansible/.*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*%.ya?ml"] = "yaml.ansible",
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
-- Theme is configured by Nixvim (colorscheme / colorschemes.catppuccin)

-- Which-key, telescope, oil, leap and the mini modules are configured by
-- Nixvim (plugins.which-key, plugins.telescope, plugins.oil, plugins.leap,
-- plugins.mini-ai, plugins.mini-surround).

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
vim.keymap.set("n", "<leader>e", require("oil").open_float, { desc = "File explorer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
vim.keymap.set("n", "<leader>tp", function() require("precognition").toggle() end, { desc = "Toggle Precognition" })

vim.keymap.set(
  "n",
  "<leader>ie",
  "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- Surround and ai text objects are configured by Nixvim (mini-surround/mini-ai)

-- Autopairs and leap are configured by Nixvim (plugins.nvim-autopairs/plugins.leap)

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

-- TODO comments are configured by Nixvim (plugins.todo-comments)

-- Precognition, trouble, noice and notify are configured by Nixvim
-- (plugins.precognition, plugins.trouble, plugins.noice, plugins.notify).

-- Lualine is configured by Nixvim (plugins.lualine)

-- Render Markdown setup is handled by nixvim module

-- ToggleTerm (setup is handled by plugins.toggleterm)
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
-- nvim-cmp and luasnip are configured by Nixvim (plugins.cmp / plugins.luasnip).
-- The autopairs integration has no declarative equivalent.
require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

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
    map("n", "<leader>ld", vim.diagnostic.open_float, "Show diagnostics")
    map("n", "<leader>lf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, "Format buffer")
  end,
})

-- Tinymist (Typst LSP) configuration is now handled by Nixvim directly
