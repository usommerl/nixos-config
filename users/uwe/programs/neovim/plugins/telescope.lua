local telescope = require('telescope')

telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        width = 0.9
      }
    }
  },
  pickers = {
    colorscheme = { theme = 'dropdown' },
    buffers = {
      sort_mru = true,
      previewer = false,
      mappings = {
        i = { ['<c-x>'] = require('telescope.actions').delete_buffer },
        n = { ['<c-x>'] = require('telescope.actions').delete_buffer }
      }
    }
  }
}

telescope.load_extension('fzf')
telescope.load_extension('zoxide')
telescope.load_extension('frecency')
telescope.load_extension('undo')

require('telescope._extensions.zoxide.config').setup({
  list_command = 'zoxide query -l --all'
})
