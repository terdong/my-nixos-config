# lib/utils.nix
{ lib, ... }:

{
  # JSON 파일을 읽어서 Nix set으로 변환하는 함수
  importJSON = path: builtins.fromJSON (builtins.readFile path);

  # 설정 가져오기
  getConfig =
    configPath:
    let
      config = importJSON configPath;
    in
    if builtins.pathExists configPath then
      config
    else
      throw "Configuration file not found: ${configPath}";

  # 시스템 환경 감지 함수
  detectEnvironment =
    let
      # systemd-detect-virt 명령어 실행
      result = builtins.exec [ "systemd-detect-virt" ];
    in
    if result == "wsl" then "wsl" else "linux";
}
