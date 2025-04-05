{ myConfig, ... }:
{
  environment.shellAliases = {
    nalias = "cat ${builtins.toString ./.}/default.nix | awk '/^[[:space:]]*[^#[:space:]]+[[:space:]]*=/ {match($0, /[[:space:]]*([^[:space:]]+)[[:space:]]*=[[:space:]]*\"([^\"]+)\"/, arr); if (arr[1] !~ /^nali/ && arr[1] != \"\") {printf \"%-15s=> %s\\n\", arr[1], arr[2]}}'";
    gspm = "git stash push my-config.toml";
    gsp = "git stash pop";
    nrf = "sudo nixos-rebuild switch --flake";
    nrfd = "nrf .";
    nfc = "nix flake check";
    nfu = "nix flake update";
    nfcd = "nfc .";
    npull = "pushd /home/${myConfig.user.name}/.dotfiles/${myConfig.nixos.bkp_conf_dir_name} && gspm && git pull --rebase && gsp && popd";
    nupdate = "nrf /home/${myConfig.user.name}/.dotfiles/${myConfig.nixos.bkp_conf_dir_name}";
    ngarbage = "sudo nix-collect-garbage -d";
  };
}
