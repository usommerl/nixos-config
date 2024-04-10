{ pkgs, ... }:
{
  programs.neovim.plugins = let
    p = pkgs.vimPlugins;
  in
  [
    p.nvim-web-devicons
    p.noice-nvim
    {
      plugin = p.lualine-nvim;
      type = "lua";
      config = ''
        require("lualine").setup {
          options = {
            component_separators = ""
          },
          sections = {
            lualine_c = {
              "filename",
              "g:metals_status",
              {
                require("noice").api.status.mode.get,
                cond = require("noice").api.status.mode.has,
                color = { fg = "WarningMsg" },
              }
            },
            lualine_x = {
              "encoding",
              { "fileformat", icons_enabled = false },
              "filetype"
            },
          },
          extensions = { "nvim-tree" }
        }
      '';
    }
  ];
}
