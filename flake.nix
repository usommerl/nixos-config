{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker.url = "github:abenz1267/walker?ref=v0.0.70";
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    nix-index-database,
    ...
  }:
  let
    inherit (nixpkgs.lib) nixosSystem attrsets;
  in {
    nixosConfigurations = {

      ares = nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = (attrsets.mergeAttrsList [ { mainUser = "uwe"; hostName = "ares"; } inputs ]);
        modules = [
          ./hosts/${specialArgs.hostName}
          home-manager.nixosModules.home-manager
          nix-index-database.nixosModules.default
          { programs.nix-index-database.comma.enable = true; }
          {
            nixpkgs.config.allowUnfree = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${specialArgs.mainUser} = import ./users/${specialArgs.mainUser};
          }
        ];
      };
    };
  };
}
