{ pkgs, ... }:
{
  environment.shellAliases = {
    nrf = "sudo nixos-rebuild switch --flake";
    nrfd = "nrsf .";
    nfc = "nix flake check";
    nfcd = "nfc .";
  };
}
