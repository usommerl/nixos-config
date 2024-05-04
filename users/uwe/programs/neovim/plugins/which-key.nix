{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.which-key-nvim;
      type = "lua";
      config = ''
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup { 
          show_help = false,
        }
      '';
    }
  ];
}
