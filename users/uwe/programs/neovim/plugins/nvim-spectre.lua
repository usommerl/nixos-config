vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = { 'spectre_panel' },
    command = [[nnoremap <buffer><silent>q :close<cr>]]
  }
)
require('spectre').setup()
