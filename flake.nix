{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
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
