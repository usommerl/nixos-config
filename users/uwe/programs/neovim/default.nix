{ pkgs, ... }:
{

  programs.neovim = with pkgs; {
    enable = true;
    package = neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = let

      colorschemes = [
        { plugin = vimPlugins.tokyonight-nvim; }
      ];

      gitsigns = [
        {
          plugin = vimPlugins.gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/gitsigns.lua;
        }
      ];

      lualine = [
        {
          plugin = vimPlugins.lualine-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/lualine.lua;
        }
        { plugin = vimPlugins.nvim-web-devicons; }
      ];

      nvim-tree = [
        {
          plugin = vimPlugins.nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-tree.lua;
        }
        { plugin = vimPlugins.nvim-web-devicons; }
      ];

      telescope = [
        {
          plugin = vimPlugins.telescope-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/telescope.lua;
        }
        { plugin = vimPlugins.telescope-undo-nvim; }
        { plugin = vimPlugins.telescope-fzf-native-nvim; }
        { plugin = vimPlugins.telescope-frecency-nvim; }
        { plugin = vimPlugins.telescope-zoxide; }
      ];

      noice = [
        {
          plugin = vimPlugins.noice-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/noice.lua;
        }
        { plugin = vimPlugins.nui-nvim; }
        { plugin = vimPlugins.nvim-notify; }
      ];

    in lib.lists.flatten [
      colorschemes
      gitsigns
      lualine
      noice
      nvim-tree
      telescope
    ];

    extraPackages = [
      zoxide
      fzf
    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
