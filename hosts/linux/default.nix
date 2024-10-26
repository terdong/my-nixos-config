{ pkgs, lib, ... }:

{
  # 부트로더 설정
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # 네트워킹 설정
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

  # X11/Wayland 설정
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # 프린터 지원
    printing.enable = true;

    # 블루투스 지원
    #bluetooth.enable = true;
  };

  # 오디오 설정
  #sound.enable = true;
  #hardware = {
  #  pulseaudio.enable = true;
  #bluetooth.enable = true;
  #};

  # 추가 패키지
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    libreoffice
    gimp
    vlc
  ];
}
