-------------------------------------------------------
-- Functions ------------------------------------------

function read_if_exists_and_then(filename, f)
  local file = io.open(filename, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    f(content)
  else
    vim.notify('File not found: ' .. filename, vim.log.levels.WARN)
  end
end

function diff_toggle()
  if vim.api.nvim_win_get_option(0, 'diff') then
    vim.cmd('windo diffoff')
  else
    vim.cmd('windo diffthis')
  end
end

-------------------------------------------------------
-- Settings -------------------------------------------

local opt = vim.opt
local indent = 2

opt.backup = false
opt.clipboard = 'unnamedplus'
opt.colorcolumn = '9999' -- See: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
opt.completeopt = { 'menu', 'noinsert', 'noselect' }
opt.cursorline = true
opt.expandtab = true
opt.list = true
opt.listchars = { tab = '▸ ', trail = '█', nbsp = '%' }
opt.number = true
opt.pumblend = 15
opt.relativenumber = true
opt.shiftwidth = indent
opt.shortmess:append("c")
opt.showmode = false
opt.signcolumn = 'yes:2'
opt.softtabstop = indent
opt.tabstop = indent
opt.termguicolors = true
opt.title = true
opt.undofile = true
opt.updatetime = 300
opt.writebackup = false

vim.cmd 'colorscheme tokyonight-moon'

-- Diagnostic related configuration
vim.diagnostic.config {
  float = { border = "rounded" },
}

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    prefix = '|', -- e.g.: '■' '●', '▎', 'x'
  }
})

-- Highlight yanked text
vim.api.nvim_create_autocmd(
  'TextYankPost',
  {
    pattern = { '*' },
    command = [[lua vim.highlight.on_yank {timeout=250, on_visual=false}]]
  }
)

-- Shortcut to close help windows
vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = { 'help' },
    command = [[nnoremap <buffer><silent>q :close<cr>]]
  }
)

-------------------------------------------------------
-- Keymaps --------------------------------------------

local map = vim.api.nvim_set_keymap
local nor = { noremap = true }
local nrs = { noremap = true, silent = true }
local nre = { noremap = true, expr = true }

vim.g.mapleader = ','

-- better up/down
vim.keymap.set('n', 'j', 'gj', { desc = "Down" })
vim.keymap.set('n', 'k', 'gk', { desc = "Up" })

-- Select windows
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Select window to the left" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Select window below" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Select window above" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Select window to the right" })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Increment/Decrement
vim.keymap.set('n', '+', '<c-a>', { desc = "Increment" })
vim.keymap.set('n', '-', '<c-x>', { desc = "Decrement" })

-- Move view
vim.keymap.set('n', '<c-e>', '6<c-e>', { desc = "Move view down" })
vim.keymap.set('n', '<c-y>', '6<c-y>', { desc = "Move view up" })

-- Misc
vim.keymap.set('n', '<leader>.', ':b#<cr>', { desc = "Switch to last buffer" })
vim.keymap.set('n', '<leader>dt', ':lua diff_toggle()<cr>', { desc = "Toggle diff on/off" })
vim.keymap.set('n', '<leader>tn', ':<c-u>tabnew<cr>', { desc = "New tab" })
vim.keymap.set('n', '<leader>tc', ':<c-u>tabclose<cr>', { desc = "Close tab" })
vim.keymap.set('n', '<leader>yd', ':<c-u>let @+ = expand("%:p:h")<cr>', { desc = "Yank current directory path" })
vim.keymap.set('n', '<leader>yf', ':<c-u>let @+ = expand("%:p")<cr>', { desc = "Yank current file path" })
vim.keymap.set('n', '<leader>yn', ':<c-u>let @+ = expand("%:p") . ":" . line(".")<cr>', { desc = "Yank current file path with line number" })

-- Git
map('n', '<leader>gd', ':<C-u>Gdiffsplit<cr>', nrs)
map('n', '<leader>gg', ':<C-u>Git<cr><C-w>o', nrs)
map('n', '<leader>gps', ':<C-u>Git push<cr>', nrs)
map('n', '<leader>gpl', ':<C-u>Git pull<cr>', nrs)
map('n', '<leader>gB', ':<C-u>Git blame<cr>', nrs)

map('c', '%%', 'getcmdtype() == ":" ? expand("%:h")."/" : "%%"', nre)
map('n', '<leader><esc>', '<cmd>nohl | Noice dismiss<cr>', nrs)
map('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', nrs)
map('n', 'gr', ':lua vim.lsp.buf.references()<cr>', nrs)
map('n', 'gn', ':lua vim.diagnostic.goto_next({ wrap = false })<cr>', nrs)
map('n', 'gp', ':lua vim.diagnostic.goto_prev({ wrap = false })<cr>', nrs)
map('n', 'K', ':lua vim.lsp.buf.hover()<cr>', nrs)
map('n', '<leader>,', ':lua vim.lsp.buf.code_action()<cr>', nrs)
map('n', '<leader>r<space>', ':<c-u>%s/\\s\\+$/<cr>', nor)
map('n', '<leader>re', ':lua vim.lsp.buf.rename()<cr>', nrs)
map('n', '<leader>S', ':<c-u>lua require("spectre").toggle()<cr>', nrs)
map('n', '<leader>sl', ':<c-u>setlocal list!<cr>', nor)
map('n', '<leader>sw', ':<c-u>set wrap!<cr>', nor)
map('n', '<leader>w', ':<c-u>Win<cr>', nrs)
map('n', '<leader>xx', ':TroubleToggle<cr>', nrs)
map('t', '<Esc>', '<C-\\><C-n>', nor)

