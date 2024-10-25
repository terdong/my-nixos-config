{
  # description = "Flexible NixOS Configuration by Darren Kim";

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
    #scala-seed.url = "github:DevInsideYou/scala-seed";
    #nix-ld.url = "github:Mic92/nix-ld";
    #nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      #flake-utils,
      nixos-wsl,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      #utils = import ./lib/utils.nix { inherit (nixpkgs) lib; };
      #config = utils.getConfig ./config.json;
      #config3 = builtins.fromJSON (builtins.readFile "/home/darren/my-nix-flake-config/config3.json");

      mkSystem =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            username = "darren";
          };

          modules = [
            ./hosts/common/default.nix
            nixos-wsl.nixosModules.wsl
            ./hosts/wsl/default.nix
            # (
            #   { config2, pkgs, ... }:
            #   let
            #     envType = utils.detectEnvironment;
            #   in
            #   {
            #     config = {
            #       networking.hostName = hostName;

            #       imports = if envType == "wsl" then [ ./hosts/wsl/default.nix ] else [ ./hosts/linux/default.nix ];
            #     };
            #   }
            # )
            home-manager.nixosModules.home-manager
            {
              #inherit config3;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.darren = import ./home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
            /*
              home-manager.nixosModules.home-manager
               {
                 home-manager.useGlobalPkgs = true;
                 home-manager.useUserPackages = true;
                 home-manager.users.${config3.user.username} = import ./home.nix;
               }
            */
          ];
        };
    in
    {
      nixosConfigurations.nixos = mkSystem "my-machine";
    };
  /*
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        #pkgs = import nixpkgs { inherit system; };

        # utils 모듈 불러오기
        utils = import ./lib/utils.nix { inherit (nixpkgs) lib; };

        # 설정 파일 불러오기
        config = utils.getConfig ./config.json;

        # 시스템 설정 생성 함수
        mkSystem =
          hostName:
          nixpkgs.lib.nixosSystem {
            inherit system;

            settings.experimental-features = [
              "nix-command"
              "flakes"
            ];

            specialArgs = {
              inherit config;
              username = config.user.username;
            };

            modules = [
              # 기본 모듈
              ./hosts/common/default.nix

              # 환경 감지 및 설정 적용 모듈
              (
                { config, pkgs, ... }:
                let
                  envType = utils.detectEnvironment;
                in
                {
                  config = {
                    networking.hostName = hostName;

                    # 환경별 설정 import
                    imports = if envType == "wsl" then [ ./hosts/wsl/default.nix ] else [ ./hosts/linux/default.nix ];
                  };
                }
              )

              # home-manager 설정
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${config.user.username} = import ./home.nix;
              }
            ];
          };
      in
      {
        # 단일 설정으로 통합
        nixosConfigurations.default = mkSystem config.system.hostname.default;
      }
    );
  */
}
