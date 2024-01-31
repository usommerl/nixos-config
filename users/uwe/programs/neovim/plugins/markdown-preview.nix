{ pkgs, ... }:
{
  programs.neovim.plugins = [
    pkgs.vimPlugins.markdown-preview-nvim
  ];
}
