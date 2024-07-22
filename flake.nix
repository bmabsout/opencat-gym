{
  description = "Python shell environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in 
        pkgs.mkShell {
          name = "python-shell";
          packages = [
            (pkgs.python3.withPackages (p: with p; 
              [
                numpy
                pybullet
                (callPackage ./stable-baselines3.nix {})
              ])
            )
          ];
        };
  };
}