{ pkgs, ... }:

{
  # 기본 시스템 설정
  time.timeZone = "Asia/Seoul";

  # 기본 사용자 설정
  users.users.darren = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    #shell = pkgs.zsh;
    #openssh.authorizedKeys.keys = config.ssh.keys;
  };

  # 환경 변수 설정
  environment = {
    # sessionVariables = {
    #   GITHUB_TOKEN = config.github.token;
    # };

    systemPackages = with pkgs; [
      nixfmt-rfc-style
      wget
      httpie
      git
      vim
      htop
      tmux
    ];
  };

  # 기본 서비스 설정
  # services = {
  #   openssh = {
  #     enable = true;
  #     settings = {
  #       PermitRootLogin = "no";
  #       PasswordAuthentication = false;
  #     };
  #   };
  # };

  # 시스템 상태 버전
  # system.stateVersion = config.system.stateVersion;
  system.stateVersion = "24.05";
}
