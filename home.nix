{ config, pkgs, ... }:

let
  userConfig = config.user;
  githubConfig = config.github;
  systemConfig = config.system;
  envType = (import ./lib/utils.nix { inherit (pkgs) lib; }).detectEnvironment;
in
{
  imports = [
    ./modules/programs
  ];

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = systemConfig.stateVersion;

    packages = with pkgs; [
      #${config.programs.terminal}
      #${config.programs.editor}
      git
      curl
      ripgrep
      fd
      tree
      jq
    ];
    /*
      ++ (
        if envType == "wsl" then
          [
            # WSL 특화 패키지
            wslu
          ]
        else
          [
            # 일반 리눅스 특화 패키지
            firefox
            thunderbird
          ]
      );
    */

    # 환경 변수 설정
    /*
      sessionVariables = {
        EDITOR = config.programs.editor;
        VISUAL = config.programs.editor;
      };
    */
  };

  # 환경별 프로그램 설정
  programs = {
    git = {
      enable = true;
      userName = userConfig.fullName;
      userEmail = userConfig.email;

      extraConfig = {
        github.user = githubConfig.username;
      };
    };

    vscode = {
      enable = true;
      extensions =
        if envType == "wsl" then
          [
            pkgs.vscode-extensions.ms-vscode-remote.remote-wsl
          ]
        else
          [
            # 리눅스 환경 확장
            pkgs.vscode-extensions.ms-vscode.cpptools
          ];
    };
  };
}
