{ pkgs }:

let
  /*
    importToml = path: builtins.fromToml (builtins.readFile path);
    getConfig =
      configPath:
      let
        config = importToml configPath;
      in
      if builtins.pathExists configPath then
        config
      else
        throw "Configuration file not found: ${configPath}";
  */

  isWSL =
    builtins.readFile (
      pkgs.runCommand "virt-type" { } ''${pkgs.systemd}/bin/systemd-detect-virt > $out''
    ) == "wsl\n";

  createFileDef = filePath: fileSource: perm: {
    "${filePath}" = {
      source = fileSource;
      onChange = "chmod ${perm} ${filePath}";
    };
  };
  existsFile = path: builtins.pathExists path;
in
{

  inherit isWSL;
}
