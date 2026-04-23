{ pkgs, ... }:
{
  programs.neovim = with pkgs; {

    plugins = let
      p = pkgs.vimPlugins;
      prompt = "> ";
    in
    [
      {
        plugin = p.fzf-lua;
        type = "lua";
        config = ''
          -- fzf-lua plugin ----------------------------------------------------------------

          local fzf = require('fzf-lua')

          fzf.setup {
            winopts = {
              width = 0.9,
              preview = {
                layout = 'horizontal',
              },
            },
            fzf_opts = {
              ['--layout'] = 'reverse',
            },
            keymap = {
              builtin = {
                ['<C-d>'] = 'preview-page-down',
                ['<C-u>'] = 'preview-page-up',
              },
            },
            files = {
              prompt = '${prompt}',
            },
            buffers = {
              prompt = '${prompt}',
              sort_lastused = true,
              previewer = false,
              actions = {
                ['ctrl-x'] = { fn = fzf.actions.buf_del, reload = true },
              },
            },
            colorschemes = {
              prompt = '${prompt}',
              winopts = { height = 0.55, width = 0.30 },
            },
          }

          -- Toggle hidden/ignored files with <C-h>, mirroring the telescope behavior
          local find_files_show_all = false
          local function my_find_files()
            if find_files_show_all then
              fzf.files {
                prompt = 'Find Files <ALL>❯ ',
                cmd = 'fd --type f --hidden --no-ignore',
                actions = {
                  ['ctrl-h'] = function()
                    find_files_show_all = false
                    my_find_files()
                  end,
                },
              }
            else
              fzf.files {
                actions = {
                  ['ctrl-h'] = function()
                    find_files_show_all = true
                    my_find_files()
                  end,
                },
              }
            end
          end

          vim.keymap.set('n', '<leader>ff', my_find_files, { desc = "Find files", silent = true })
          vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = "Buffers", silent = true })
          vim.keymap.set('n', '<leader>fc', fzf.colorschemes, { desc = "Colorschemes", silent = true })
          vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = "Live grep", silent = true })
          vim.keymap.set('n', '<leader>fk', fzf.keymaps, { desc = "Keymaps", silent = true })
          vim.keymap.set('n', '<leader>fr', fzf.oldfiles, { desc = "Recent files", silent = true })
          vim.keymap.set('n', '<leader>fR', fzf.registers, { desc = "Registers", silent = true })
          vim.keymap.set('n', '<leader>gl', fzf.git_commits, { desc = "Git commits", silent = true })
          vim.keymap.set('n', '<leader>gL', fzf.git_bcommits, { desc = "Git buffer commits", silent = true })
          vim.keymap.set('n', '<leader>gb', fzf.git_branches, { desc = "Git branches", silent = true })
          vim.keymap.set('n', '<leader>u', fzf.changes, { desc = "Changes", silent = true })

          -- Zoxide integration via fzf
          vim.keymap.set('n', 'Z', function()
            local zoxide = require('fzf-lua')
            zoxide.fzf_exec('zoxide query -l --all', {
              prompt = '${prompt}',
              actions = {
                ['default'] = function(selected)
                  vim.cmd('cd ' .. selected[1])
                  vim.notify('cd ' .. selected[1])
                end,
              },
            })
          end, { desc = "Zoxide", silent = true })
        '';
      }
    ];

    extraPackages = [
      zoxide
      fzf
    ];

  };
}
