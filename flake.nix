{
  description = "NixOS and home-manager configuration";

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
  };

  outputs = inputs@{ 
    nixpkgs, 
    home-manager, 
    ... 
  }: let 
    inherit (nixpkgs.lib) nixosSystem attrsets;
    args = attrsets.mergeAttrsList [ {username = "uwe";} inputs ];
  in {
    nixosConfigurations = {

      ares = nixosSystem rec {
	system = "x86_64-linux";
	specialArgs = args;
	modules = [
	  ./hosts/configuration.nix
	  ./modules/system-nixos-label.nix
	  ./modules/package-config.nix
          home-manager.nixosModules.home-manager 
	  {
	    home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${args.username} = import ./users/${args.username};
          }
	];
      };
    };
  };
}
