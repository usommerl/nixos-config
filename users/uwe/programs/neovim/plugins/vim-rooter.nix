{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.vim-rooter;
      type = "lua";
      config = ''vim.g.rooter_silent_chdir = 1'';
    }
  ];
}
