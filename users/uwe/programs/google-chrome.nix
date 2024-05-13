{ pkgs, ... }:
with pkgs;
{
  # xdg-open is looking for a 'google-chrome' command
  home.packages = [
    (writeShellScriptBin "google-chrome" "exec -a $0 ${google-chrome}/bin/google-chrome-stable $@")
  ];

  # To start the Google Chrome browser via an application runner
  xdg.desktopEntries.chrome = {
    name = "Chrome";
    genericName = "Web Browser";
    icon = "google-chrome";
    type = "Application";
    exec = "google-chrome-stable";
    terminal = false;
    startupNotify = true;
    categories = [ "Application" "Network" "WebBrowser" ];
    mimeType = [
      "application/pdf"
      "application/rdf+xml"
      "application/rss+xml"
      "application/xhtml+xml"
      "application/xhtml_xml"
      "application/xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/webp"
      "text/html"
      "text/xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };
}
