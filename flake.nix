{
  description = "CI Containers from Zeus Network";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
            ];
          };
        in
        {
          formatter = pkgs.treefmt;

          devShells.default = pkgs.callPackage ./devshell { };

          checks = {
            format = pkgs.callPackage ./devshell/format.nix { };
          };
        })) // {
      overlays.default = final: prev: { };
    };
}
