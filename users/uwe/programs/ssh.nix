{ ... }:
with builtins;
let
  mkMatchBlocks = args : listToAttrs ( map (name: {
    inherit name;
    value = {
      hostname = "${name}.${args.domain}";
      user = args.user;
    };
  }) args.names );
in
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
    } // mkMatchBlocks {
      user = "uwe";
      domain = "tail15a8b.ts.net";
      names = [ "ares" "dolus" "eris" "nyx" "ceto-mac" ];
    } // mkMatchBlocks {
      user = "uwe.sommerlatt";
      domain = "exelonix.com";
      names = [ "www" "iot" "dev.iot" "noia" "dev.noia" "vodafone" "obre" "dev.obre" "sftp" "demo" "fockeberg" "dev" ];
    };
  };
}
