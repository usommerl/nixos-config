{ pkgs, ... }:
{
  programs.neovim = with pkgs; {

    plugins = let
      p = pkgs.vimPlugins;
    in
    [
      p.plenary-nvim
      p.nvim-web-devicons
      {
        plugin = p.nvim-spectre;
        type = "lua";
        config = ''
          vim.api.nvim_create_autocmd(
            'FileType',
            {
              pattern = { 'spectre_panel' },
              command = [[nnoremap <buffer><silent>q :close<cr>]]
            }
          )
          require('spectre').setup()
        '';
      }
    ];

    extraPackages = [
      ripgrep
    ];
  };
}
