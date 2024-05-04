{ pluginFromGitHub, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = (pluginFromGitHub "245d16328c47a132574e0fa4298d24a0f78b20b0" "main" "AndrewRadev/linediff.vim");
      type = "lua";
      config = ''
        vim.keymap.set('n', '<leader>dl', ':Linediff<cr>', { desc = "Diff line" })
        vim.keymap.set('v', '<leader>dl', ':Linediff<cr>', { desc = "Diff line" })
      '';
    }
  ];
}
