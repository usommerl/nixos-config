{ pkgs, lib, ... }:
let
  pluginFromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in
{
  _module.args.pluginFromGitHub = pluginFromGitHub;

  programs.neovim = with pkgs; {
    enable = true;
    package = neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./init.lua;
  };

  imports = [
    ./plugins/bufferline.nix
    ./plugins/colorschemes.nix
    ./plugins/comment.nix
    ./plugins/gitsigns.nix
    ./plugins/indent-blankline.nix
    ./plugins/linediff.nix
    ./plugins/lualine.nix
    ./plugins/markdown-preview.nix
    ./plugins/noice.nix
    ./plugins/nvim-spectre.nix
    ./plugins/nvim-surround.nix
    ./plugins/nvim-tree.nix
    ./plugins/nvim-ufo.nix
    ./plugins/sideways-vim.nix
    ./plugins/statuscol.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    ./plugins/vim-rooter.nix
  ];
}
