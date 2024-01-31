{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.indent-blankline-nvim;
      type = "lua";
      config = ''
        require("ibl").setup {
          -- indent-blankline character.
          indent = { char = '▏' },
          scope = {
            show_start = false,
            enabled = true,
            exclude = { language = { 'scala' } }
          },
          exclude = {
            filetypes = { 'help', 'terminal', 'dashboard', 'packer', 'NvimTree' },
            buftypes = { 'terminal' },
          }
          -- indent_blankline_show_first_indent_level = true,
        }
      '';
    }
  ];
}
