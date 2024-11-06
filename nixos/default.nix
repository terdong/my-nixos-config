{ nixos-wsl }:
{
  pkgs,
  myConfig,
  myUtils,
  ...
}:
let
  platformConfig =
    if myUtils.isWSL then (import ./platforms/wsl { inherit nixos-wsl; }) else ./platforms/linux;
  sys = myConfig.system;
in
{
  imports = [
    platformConfig
    ./modules
  ];

  system.stateVersion = sys.state_version;
  time.timeZone = sys.time_zone;
  networking.hostName = sys.host_name;
  i18n.defaultLocale = sys.locale;

  users = {
    defaultUserShell = pkgs.${sys.shell};
    users.${myConfig.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      #shell = pkgs.${myConfig.system.shell}; # personal
      ignoreShellProgramCheck = true;
    };
    users.root.ignoreShellProgramCheck = true;
  };

  environment = {
    systemPackages = with pkgs; [ nixfmt-rfc-style ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
