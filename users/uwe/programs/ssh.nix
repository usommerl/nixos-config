{ ... }:
let
  mkHost = user: domain: subdomain: {
    name = subdomain;
    value = {
      hostname = "${subdomain}.${domain}";
      user = user;
    };
  };
in
{
  programs.ssh = with builtins; {
    enable = true;
    matchBlocks = {
      "harpocrates" = {
        hostname = "harpocrates.tail15a8b.ts.net";
        port = 7022;
        user = "uwe";
        setEnv = {
          TERM = "xterm";
        };
      };
    } // (listToAttrs (
     map (mkHost "uwe" "tail15a8b.ts.net")
         [ "ares" "dolus" "eris" "nyx" "ceto-mac" ]
    )) // (listToAttrs (
     map (mkHost "uwe.sommerlatt" "exelonix.com")
         [ "www" "iot" "dev.iot" "noia" "dev.noia" "vodafone" "obre" "dev.obre" "sftp" "demo" "fockeberg" "dev" ]
    ));
  };
}
