{ pkgs, ... }:
{
  environment.shellAliases = {
    nrf = "sudo nixos-rebuild switch --flake";
    nrfd = "nrf .";
    nfc = "nix flake check";
    nfcd = "nfc .";
  };
}
