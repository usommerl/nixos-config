{ pluginFromGitHub, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = (pluginFromGitHub "ddae71ef5f94775d101c1c70032ebe8799f32745" "main" "AndrewRadev/linediff.vim");
      type = "lua";
      config = ''
        vim.keymap.set('n', '<leader>dl', ':Linediff<cr>', { desc = "Diff line", silent = true })
        vim.keymap.set('v', '<leader>dl', ':Linediff<cr>', { desc = "Diff line", silent = true })
      '';
    }
  ];
}
