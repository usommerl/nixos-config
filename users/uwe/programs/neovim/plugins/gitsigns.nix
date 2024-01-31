{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.gitsigns-nvim;
      type = "lua";
      config = ''
        require('gitsigns').setup({
          signs = {
            add = { text = '│' },
            change = { text = '│' },
            delete = { text = '│' },
            topdelete = { text = '│' },
            changedelete = { text = '│' },
          },
        })
      '';
    }
  ];
}
