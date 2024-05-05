{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.vim-fugitive;
      type = "lua";
      config = ''
        --- Fugitive plugin -----------------------------------
        vim.keymap.set('n', '<leader>gd', ':<C-u>Gdiffsplit<cr>', { desc = "Git diff", silent = true })
        vim.keymap.set('n', '<leader>gg', ':<C-u>Git<cr><C-w>o', { desc = "Git status", silent = true })
        vim.keymap.set('n', '<leader>gps', ':<C-u>Git push<cr>', { desc = "Git push", silent = true })
        vim.keymap.set('n', '<leader>gpl', ':<C-u>Git pull<cr>', { desc = "Git pull", silent = true })
        vim.keymap.set('n', '<leader>gB', ':<C-u>Git blame<cr>', { desc = "Git blame", silent = true })

        vim.api.nvim_create_autocmd(
          'FileType',
          { pattern = { 'fugitive', 'git' }, command = [[nnoremap <buffer><silent>q :bd<cr>]] }
        )
      '';
    }
  ];
}
