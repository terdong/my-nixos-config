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

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

  environment = {
    systemPackages = with pkgs; [
      wslu
      wsl-open
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}
