{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-surround;
      type = "lua";
      config = ''require("nvim-surround").setup()'';
    }
  ];
}
