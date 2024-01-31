{ pkgs, ... }:
{
  programs.neovim.plugins = let
    p = pkgs.vimPlugins;
  in
  [
    p.nvim-web-devicons
    {
      plugin = p.bufferline-nvim;
      type = "lua";
      config = ''
        vim.opt.termguicolors = true
        require("bufferline").setup {
          options = {
            mode = "tabs",
            always_show_bufferline = false
          }
        }
      '';
    }
  ];
}
