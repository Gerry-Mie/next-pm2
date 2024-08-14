   { pkgs ? import <nixpkgs> {} }:
   pkgs.mkShell {
     buildInputs = [
       pkgs.php82
       # Add other dependencies as needed
     ];
   }
