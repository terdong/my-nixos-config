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
    #flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      #flake-utils,
      nixos-wsl,
    }@inputs:
    let
      myConfig = builtins.fromTOML (builtins.readFile ./my-config.toml);
      system = myConfig.system.name;
      pkgs = nixpkgs.legacyPackages.${system};
      utils = import ./lib/utils.nix { inherit pkgs; };

      platformConfig =
        if utils.isWSL then
          (import ./hosts/wsl/default.nix { inherit nixos-wsl; })
        else
          ./hosts/linux/default.nix;

    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit myConfig;
          #inherit utils;
        };
        #imports = [ ./modules/programs ];
        modules = [
          ./hosts/common/default.nix
          platformConfig
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit myConfig;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${myConfig.user.name} = ./home.nix;
            };

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
