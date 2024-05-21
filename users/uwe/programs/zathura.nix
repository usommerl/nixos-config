{
  programs.zathura = {
    enable = true;

    mappings = {
      "<C-s>" = "toggle_statusbar";
      d = "scroll half-down";
      u = "scroll half-up";
      D = "set 'pages-per-row 2'";
      S = "set 'pages-per-row 1'";
    };

    options = {
      guioptions = ".";
      selection-clipboard = "clipboard";
      first-page-column = 2;
      sandbox = "none";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
    };
  };
}
