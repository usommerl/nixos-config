{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "google-chrome" "exec -a $0 ${google-chrome}/bin/google-chrome-stable $@")
    (writeShellScriptBin "chrome" "exec -a $0 ${google-chrome}/bin/google-chrome-stable $@")
  ];
}
