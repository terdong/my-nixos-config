{ config, pkgs, ... }@inputs:

inputs.nixos-wsl.nixosModules.default {
  wsl = {
    enable = true;
    defaultUser = config.users.users.${config.username}.name;
    nativeSystemd = true;

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

  # WSL 특화 패키지
  environment.systemPackages = with pkgs; [
    wslu
    wsl-open
    #windows-terminal
  ];

  # WSL 특화 설정
  security.sudo.wheelNeedsPassword = false; # WSL 환경에서 편의성을 위해
}
