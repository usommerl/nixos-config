require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { 'gitcommit' }
  },
  incremental_selection = { enable = true },
  indent = { enable = true }
})
