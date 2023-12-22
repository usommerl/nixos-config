{
  programs.ssh = {
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
    } // (builtins.listToAttrs (
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
     [ "ares" "nyx" "dolus" ]
    ));
  };
}
