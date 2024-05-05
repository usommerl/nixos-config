{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.sideways-vim;
      type = "lua";
      config = ''
        vim.keymap.set('n', '<A-h>', ':SidewaysLeft<cr>', { desc = "Sideways left", silent = true })
        vim.keymap.set('n', '<A-l>', ':SidewaysRight<cr>', { desc = "Sideways right", silent = true })
      '';
    }
  ];
}
