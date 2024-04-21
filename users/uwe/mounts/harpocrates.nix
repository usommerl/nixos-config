{ config, ... }:
let
  user = "uwe";
  uid = toString config.users.users.${user}.uid;
in
{
  # TODO: Credentials file?
  fileSystems."/mnt/${user}/harpocrates" = {
    device = "//harpocrates.tail15a8b.ts.net/homes/${user}";
    fsType = "cifs";
    options = [
      "noauto,x-systemd.automount"
      "x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
      "uid=${uid},gid=100,dir_mode=0700,file_mode=0600,nobrl"
      "credentials=/home/${user}/.private/harpocrates"
    ];
  };
}
