{
  description = "A flake for scala project ";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";
  # 2024-11-09: latest nixpkgs has a bug that causes the vscode cannot start lsp with metals.
  #inputs.nixpkgsForGraal.url = "github:NixOS/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # Globally configure all packages to use GraalVM instead of the default jdk/jre via Overlay
          overlays = [
            (final: prev: {
              jdk = final.graalvmPackages.graalvm-ce;
              jre = final.graalvmPackages.graalvm-ce;
            })
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            graalvmPackages.graalvm-ce
            sbt
            mill
            nodejs_24
            scala-cli
          ];
        };
      }
    );
}
