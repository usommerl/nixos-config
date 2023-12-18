{ self, nixpkgs, ... }: let
  inherit (nixpkgs) lib;
in {
  system.nixos.label =
  if self.sourceInfo ? lastModifiedDate && self.sourceInfo ? shortRev
  then "${lib.substring 0 8 self.sourceInfo.lastModifiedDate}.${self.sourceInfo.shortRev}"
  else lib.warn "Repo is dirty, revision will not be available in system label" "dirty";
}
