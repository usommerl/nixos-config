{ pkgs, ... }:
{
  programs.neovim.plugins = [
    pkgs.vimPlugins.sideways-vim
  ];
}
