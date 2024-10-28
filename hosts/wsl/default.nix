{ nixos-wsl }:
{
  pkgs,
  lib,
  myConfig,
  ...
}:
{
  imports = [ nixos-wsl.nixosModules.default ];

  wsl = {
    enable = true;
    defaultUser = myConfig.user.name;
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

  environment = {
    # https://github.com/nix-community/NixOS-WSL/issues/472
    # sessionVariables = {
    #   PATH = [ "/mnt/c/Users/darren/AppData/Local/Programs/Microsoft VS Code/Code.exe" ];
    # };
    extraInit = ''export PATH="$PATH:${myConfig.programs.vscode_path}"'';
    systemPackages = with pkgs; [
      wslu
      wsl-open
      #nixfmt-rfc-style
      #windows-terminal
    ];
  };

  # WSL 특화 설정
  security.sudo.wheelNeedsPassword = false; # WSL 환경에서 편의성을 위해
}
