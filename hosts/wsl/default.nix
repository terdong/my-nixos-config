{ nixos-wsl }:
{
  pkgs,
  lib,
  ...
}:
{
  imports = [ nixos-wsl.nixosModules.default ];
  #system.stateVersion = "24.05";

  wsl = {
    enable = true;
    defaultUser = "darren";
    #nativeSystemd = true;

    wslConf = {
      automount = {
        enabled = true;
        mountFsTab = true;
      };
      network = {
        generateHosts = true;
        generateResolvConf = true;
      };
      interop = {
        enabled = true;
        appendWindowsPath = false;
      };
    };
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

  # WSL 특화 패키지
  environment.systemPackages = with pkgs; [
    wslu
    wsl-open
    #nixfmt-rfc-style
    #windows-terminal
  ];

  # # WSL 특화 설정
  security.sudo.wheelNeedsPassword = false; # WSL 환경에서 편의성을 위해
}
