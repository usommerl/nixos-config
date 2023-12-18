{ self, nixpkgs, ... }: let
  inherit (nixpkgs) lib;
  inherit (lib) warn;
  inherit (self) sourceInfo;
in {
  system.nixos.label =
  if sourceInfo ? lastModifiedDate && sourceInfo ? shortRev
  then "${sourceInfo.lastModifiedDate}.${sourceInfo.shortRev}-clean"
  else warn "Repository is dirty!" "${sourceInfo.lastModifiedDate}.${sourceInfo.dirtyShortRev}";
}
