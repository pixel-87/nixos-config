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
      vim.cmd("silent! write")
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

-- Harpoon is configured by Nixvim (plugins.harpoon + top-level keymaps)

-- Keymaps (general)
vim.keymap.set("n", "<leader>e", require("oil").open_float, { desc = "File explorer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

vim.keymap.set(
  "n",
  "<leader>ie",
  "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- Surround and ai text objects are configured by Nixvim (mini-surround/mini-ai)

-- Autopairs and leap are configured by Nixvim (plugins.nvim-autopairs/plugins.leap)

-- Gitsigns (including its keymaps) is configured by Nixvim (plugins.gitsigns).

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

-- LSP keymaps, diagnostics and formatting are configured by Nixvim
-- (plugins.lsp.keymaps, diagnostic.settings, plugins.conform-nvim).
