   { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-20.09.tar.gz") {} }:
   pkgs.mkShell {
     buildInputs = [
       pkgs.php82
       # Add other dependencies as needed
     ];
   }
