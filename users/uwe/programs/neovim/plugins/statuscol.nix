{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.statuscol-nvim;
      type = "lua";
      config = ''
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
            {
              sign = { name = { "Diagnostic" }, maxwidth = 1, auto = false },
              click = "v:lua.ScSa"
            },
            { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
            {
              sign = { namespace = { ".*" }, maxwidth = 2, colwidth = 1, auto = false, fillchar = " " },
              click = "v:lua.ScSa"
            },
          }
        })
      '';
    }
  ];
}
