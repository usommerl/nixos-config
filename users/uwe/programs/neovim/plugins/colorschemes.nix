{ pkgs, ...}:
{
  programs.neovim = with pkgs; {

    plugins = let
      p = pkgs.vimPlugins;
    in [
      p.tokyonight-nvim
      p.nightfox-nvim
      p.edge
      p.kanagawa-nvim
      p.catppuccin-nvim
      p.oceanic-next
      p.vim-one
      p.onenord-nvim
      p.material-nvim
    ];
  };

}
