{ pkgs, ... }:
{
  programs.firefox.enable = true;

  xdg.desktopEntries.firefox = {
    name = "Firefox";
    genericName = "Web Browser";
    icon = "firefox";
    type = "Application";
    exec = "firefox --new-window %U";
    terminal = false;
    startupNotify = true;
    categories = [ "Application" "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser"       = [ "firefox.desktop" ];
      "text/html"                 = [ "firefox.desktop" ];
      "x-scheme-handler/http"     = [ "firefox.desktop" ];
      "x-scheme-handler/https"    = [ "firefox.desktop" ];
      "x-scheme-handler/about"    = [ "firefox.desktop" ];
      "x-scheme-handler/unknown"  = [ "firefox.desktop" ];
    };
  };
}
