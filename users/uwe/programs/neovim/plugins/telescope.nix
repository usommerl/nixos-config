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
          -- Telescope plugin --------------------------------------------------------------

          -- See: https://github.com/nvim-telescope/telescope.nvim/issues/2874#issuecomment-1900967890
          local my_find_files
          my_find_files = function(opts, no_ignore)
            opts = opts or {}
            no_ignore = vim.F.if_nil(no_ignore, false)
            opts.attach_mappings = function(_, map)
              map({ "n", "i" }, "<C-h>", function(prompt_bufnr) -- <C-h> to toggle modes
                local prompt = require("telescope.actions.state").get_current_line()
                require("telescope.actions").close(prompt_bufnr)
                no_ignore = not no_ignore
                my_find_files({ default_text = prompt }, no_ignore)
              end)
              return true
            end

            if no_ignore then
              opts.no_ignore = true
              opts.hidden = true
              opts.prompt_title = "Find Files <ALL>"
              require("telescope.builtin").find_files(opts)
            else
              opts.prompt_title = "Find Files"
              require("telescope.builtin").find_files(opts)
            end
          end

          vim.keymap.set('n', '<leader>ff', my_find_files, { desc = "Telescope find_files" })
          vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>')
          vim.keymap.set('n', '<leader>fc', ':Telescope colorscheme<cr>')
          vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>')
          vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>')
          vim.keymap.set('n', '<leader>fm', ':Telescope metals commands<cr>')
          vim.keymap.set('n', '<leader>fr', ':Telescope frecency<cr>')
          vim.keymap.set('n', '<leader>fR', ':Telescope registers<cr>')
          vim.keymap.set('n', '<leader>gl', ':Telescope git_commits<cr>')
          vim.keymap.set('n', '<leader>gL', ':Telescope git_bcommits<cr>')
          vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<cr>')
          vim.keymap.set('n', 'Z', ':Telescope zoxide list<cr>')
          vim.keymap.set('n', '<leader>u', ':Telescope undo<cr>')

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
