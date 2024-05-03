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
     map
       (
         name: {
           inherit name;
           value = {
             hostname = "${name}.tail15a8b.ts.net";
             user = "uwe";
           };
         }
       )
     [ "ares" "dolus" "eris" "nyx" "ceto-mac" ]
    )) // (listToAttrs (
     map
       (
         name: {
           inherit name;
           value = {
             hostname = "${name}.exelonix.com";
             user = "uwe.sommerlatt";
           };
         }
       )
     [ "www" "iot" "dev.iot" "noia" "dev.noia" "vodafone" "obre" "dev.obre" "sftp" "demo" "fockeberg" "dev" ]
    ));
  };
}
