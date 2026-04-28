{ pkgs, ... }:
{
  programs.neovim = with pkgs; {

    plugins = let
      p = pkgs.vimPlugins;
      prompt = "> ";
    in
    [
      {
        plugin = p.snacks-nvim;
        type = "lua";
        config = ''
          -- snacks.picker plugin -----------------------------------------------------------

          local snacks = require('snacks')

          snacks.setup {
            picker = {
              enabled = true,
              layout = {
                preset = 'default',
                layout = {
                  width = 0.9,
                },
              },
              sources = {
                buffers = {
                  sort_lastused = true,
                  preview = false,
                  layout = { preset = 'select' },
                },
                colorschemes = {
                  finder = "vim_colorschemes",
                  format = "text",
                  preview = "colorscheme",
                  layout = { preset = 'vertical' },
                  confirm = function(picker, item)
                    picker:close()
                    if item then
                      picker.preview.state.colorscheme = nil
                      vim.schedule(function()
                        vim.cmd("colorscheme " .. item.text)
                      end)
                    end
                  end,
                },
              },
              win = {
                input = {
                  keys = {
                    ['<C-d>'] = { 'preview_scroll_down', mode = { 'n', 'i' } },
                    ['<C-u>'] = { 'preview_scroll_up', mode = { 'n', 'i' } },
                  },
                },
              },
            },
          }

          -- Toggle hidden/ignored files with <C-h>, mirroring the telescope behavior
          local find_files_show_all = false
          local function my_find_files()
            snacks.picker.files {
              hidden = find_files_show_all,
              ignored = find_files_show_all,
              title = find_files_show_all and 'Find Files <ALL>' or 'Find Files',
              win = {
                input = {
                  keys = {
                    ['<C-h>'] = {
                      function(self)
                        find_files_show_all = not find_files_show_all
                        self:close()
                        my_find_files()
                      end,
                      mode = { 'n', 'i' },
                      desc = 'Toggle hidden/ignored',
                    },
                  },
                },
              },
            }
          end

          vim.keymap.set('n', '<leader>ff', my_find_files, { desc = "Find files", silent = true })
          vim.keymap.set('n', '<leader>fb', function() snacks.picker.buffers() end, { desc = "Buffers", silent = true })
          vim.keymap.set('n', '<leader>fc', function() snacks.picker.colorschemes() end, { desc = "Colorschemes", silent = true })
          vim.keymap.set('n', '<leader>fg', function() snacks.picker.grep() end, { desc = "Live grep", silent = true })
          vim.keymap.set('n', '<leader>fk', function() snacks.picker.keymaps() end, { desc = "Keymaps", silent = true })
          vim.keymap.set('n', '<leader>fr', function() snacks.picker.recent() end, { desc = "Recent files", silent = true })
          vim.keymap.set('n', '<leader>fR', function() snacks.picker.registers() end, { desc = "Registers", silent = true })
          vim.keymap.set('n', '<leader>gl', function() snacks.picker.git_log() end, { desc = "Git commits", silent = true })
          vim.keymap.set('n', '<leader>gL', function() snacks.picker.git_log_file() end, { desc = "Git buffer commits", silent = true })
          vim.keymap.set('n', '<leader>gb', function() snacks.picker.git_branches() end, { desc = "Git branches", silent = true })
          vim.keymap.set('n', '<leader>u', function() snacks.picker.undo() end, { desc = "Undo history", silent = true })

          -- Zoxide integration
          vim.keymap.set('n', 'Z', function()
            snacks.picker.pick({
              source = 'zoxide',
              title = 'Zoxide',
              finder = function(opts, ctx)
                local proc = vim.system({ 'zoxide', 'query', '-l', '--all' }, { text = true }):wait()
                local items = {}
                for line in proc.stdout:gmatch('[^\n]+') do
                  table.insert(items, { text = line, file = line })
                end
                return items
              end,
              confirm = function(picker, item)
                picker:close()
                if item then
                  vim.cmd('cd ' .. item.text)
                  vim.notify('cd ' .. item.text)
                end
              end,
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
