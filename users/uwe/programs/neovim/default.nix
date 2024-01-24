{ pkgs, ... }:
{

  programs.neovim = with pkgs; {
    enable = true;
    package = neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with vimPlugins; let

      colorschemes = [
        tokyonight-nvim
        nightfox-nvim
        edge
        kanagawa-nvim
        catppuccin-nvim
        oceanic-next
        vim-one
        onenord-nvim
        material-nvim
      ];

      gitsigns = [
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/gitsigns.lua;
        }
      ];

      lualine = [
        {
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/lualine.lua;
        }
        nvim-web-devicons
      ];

      nvim-tree = [
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-tree.lua;
        }
        nvim-web-devicons
      ];

      telescope = [
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/telescope.lua;
        }
        telescope-undo-nvim
        telescope-fzf-native-nvim
        telescope-frecency-nvim
        telescope-zoxide
      ];

      noice = [
        {
          plugin = noice-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/noice.lua;
        }
        nui-nvim
        nvim-notify
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
