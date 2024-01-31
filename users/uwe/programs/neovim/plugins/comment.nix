{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.comment-nvim;
      type = "lua";
      config = ''require("Comment").setup()'';
    }
  ];
}
