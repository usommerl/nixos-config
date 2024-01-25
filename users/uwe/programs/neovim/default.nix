{ pkgs, ... }:
{

  programs.neovim = with pkgs; {
    enable = true;
    package = neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    plugins = let

      p = pkgs.vimPlugins;

      colorschemes = [
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

      treesitter = {
        plugin = p.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./plugins/treesitter.lua;
      };

      indent-blankline = {
        plugin = p.indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/indent-blankline.lua;
      };

      nvim-ufo = [
        {
          plugin = p.nvim-ufo;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-ufo.lua;
        }
        p.promise-async
      ];

      nvim-surround = {
        plugin = p.nvim-surround;
        type = "lua";
        config = ''require("nvim-surround").setup()'';
      };

      vim-rooter = {
        plugin = p.vim-rooter;
        type = "lua";
        config = ''vim.g.rooter_silent_chdir = 1'';
      };

      statuscol = {
        plugin = p.statuscol-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/statuscol.lua;
      };

      gitsigns = {
        plugin = p.gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/gitsigns.lua;
      };

      lualine = [
        {
          plugin = p.lualine-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/lualine.lua;
        }
        p.nvim-web-devicons
      ];

      nvim-tree = [
        {
          plugin = p.nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-tree.lua;
        }
        p.nvim-web-devicons
      ];

      nvim-spectre = [
        {
          plugin = p.nvim-spectre;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-spectre.lua;
        }
        p.plenary-nvim
        p.nvim-web-devicons
      ];

      telescope = [
        {
          plugin = p.telescope-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/telescope.lua;
        }
        p.plenary-nvim
        p.telescope-undo-nvim
        p.telescope-fzf-native-nvim
        p.telescope-frecency-nvim
        p.telescope-zoxide
      ];

      noice = [
        {
          plugin = p.noice-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/noice.lua;
        }
        p.nui-nvim
        p.nvim-notify
      ];

    in lib.lists.flatten [
      colorschemes
      treesitter
      gitsigns
      lualine
      indent-blankline
      noice
      nvim-tree
      nvim-ufo
      nvim-surround
      nvim-spectre
      telescope
      statuscol
      vim-rooter
      p.sideways-vim
    ];

    extraPackages = [
      zoxide  # telescope
      fzf     # telescope
      ripgrep # nvim-spectre
    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
