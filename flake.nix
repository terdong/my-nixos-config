{
  description = "Flexible NixOS Configuration by Darren Kim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      #flake-utils,
      nixos-wsl,
      nixvim,
    }:
    let
      myConfig = builtins.fromTOML (builtins.readFile ./my-config.toml);
      system = myConfig.system.name;
      pkgs = nixpkgs.legacyPackages.${system};
      myUtils = import ./lib/my-utils.nix { inherit pkgs; };

      /*
        platformConfig =
             if utils.isWSL then
               (import ./hosts/wsl/default.nix { inherit nixos-wsl; })
             else
               ./hosts/linux/default.nix;
      */

    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        #inherit specialArgs;
        specialArgs = {
          inherit myConfig;
          inherit myUtils;
        };

        modules = [
          (import ./hosts { inherit nixos-wsl; })
          #(import ./hosts/wsl/default.nix { inherit nixos-wsl; })
          /*
            (import ./hosts {
              inherit nixos-wsl pkgs;
              #inherit specialArgs;
              inherit (specialArgs) myConfig utils;
            })
          */
          #./hosts
          #platformConfig
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit myConfig;
                inherit nixvim;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${myConfig.user.name} = ./home;
            };

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
