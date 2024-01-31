{ pkgs, ... }:
{
  programs.neovim = with pkgs; {

    plugins = let
      p = pkgs.vimPlugins;
    in
    [
      p.plenary-nvim
      p.telescope-undo-nvim
      p.telescope-fzf-native-nvim
      p.telescope-frecency-nvim
      p.telescope-zoxide
      {
        plugin = p.telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require('telescope')

          telescope.setup {
            defaults = {
              layout_config = {
                horizontal = {
                  width = 0.9
                }
              }
            },
            pickers = {
              colorscheme = { theme = 'dropdown' },
              buffers = {
                sort_mru = true,
                previewer = false,
                mappings = {
                  i = { ['<c-x>'] = require('telescope.actions').delete_buffer },
                  n = { ['<c-x>'] = require('telescope.actions').delete_buffer }
                }
              }
            }
          }

          telescope.load_extension('fzf')
          telescope.load_extension('zoxide')
          telescope.load_extension('frecency')
          telescope.load_extension('undo')

          require('telescope._extensions.zoxide.config').setup({
            list_command = 'zoxide query -l --all'
          })
        '';
      }
    ];

    extraPackages = [
      zoxide
      fzf
    ];

  };
}
