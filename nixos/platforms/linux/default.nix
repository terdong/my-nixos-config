{ pkgs, lib, ... }:

{
  # Bootloader settings
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking settings
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
    };
  };

  # X11/Wayland settings
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # Printer support
    #printing.enable = true;

    # Bluetooth support
    #bluetooth.enable = true;
  };

  # Audio settings
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
  };

  # Additional packages
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    libreoffice
    gimp
    vlc
  ];
}
