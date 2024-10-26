# lib/utils.nix
{ pkgs }:

let
  # JSON 파일을 읽어서 Nix 표현식으로 변환하는 함수
  importJSON = path: builtins.fromJSON (builtins.readFile path);

  # 설정 가져오기
  getConfig =
    configPath:
    let
      # JSON 파일을 읽어서 Nix set으로 변환하는 함수
      config = importJSON configPath;
    in
    if builtins.pathExists configPath then
      config
    else
      throw "Configuration file not found: ${configPath}";

  # 시스템 환경 감지 함수
  isWSL =
    builtins.readFile (
      pkgs.runCommand "virt-type" { } ''${pkgs.systemd}/bin/systemd-detect-virt > $out''
    ) == "wsl\n";
in
/*
  detectEnvironment = builtins.replaceStrings [ "\n" ] [ "" ] (
    builtins.readFile pkgs.runCommand "virt-type" { } ''
      ${pkgs.systemd}/bin/systemd-detect-virt > $out
    ''
  );
*/
/*
  detectEnvironment =
   let
     # systemd-detect-virt 명령어 실행
     result = pkgs.runCommand "detect-virt" { } ''
             result=$(systemd-detect-virt || true)
             echo "$result" > $out
     '';
   in
   if result == "wsl" then "wsl" else "linux";
*/
{

  inherit getConfig isWSL;
}
