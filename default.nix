{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-22.05.tar.gz") {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.php82
    pkgs.composer
    # add other dependencies
  ];
}
