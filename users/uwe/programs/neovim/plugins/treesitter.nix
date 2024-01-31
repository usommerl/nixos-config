{ pkgs, ... }:
{
  programs.neovim = with pkgs; {

    plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (l:
          [
           l.bash
           l.lua
           l.json
           l.markdown
           l.nix
           l.python
           l.rust
           l.scala
           l.scss
           l.typescript
           l.yaml
          ]
        );
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup({
            highlight = {
              enable = true,
              disable = { 'gitcommit' }
            },
            incremental_selection = { enable = true },
            indent = { enable = true }
          })
        '';
      }
    ];
  };
}
